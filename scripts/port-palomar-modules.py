#!/usr/bin/env python3
"""One-time, idempotent source-header migration; never changes proof bodies.

The documented Lean module migration recipe is module/public import/expose.
Compatibility options retain legacy private references and proof elaboration.
This script deliberately fails on an unexpected header instead of guessing.
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import urllib.request

MATHLIB = '065356127b1dc0016f66b7283ce0ce2c4055aa55'
UPSTREAM = '4eaee87548250b2682affda7d05d947c05554bae'

def fetch(url):
    with urllib.request.urlopen(url, timeout=60) as response:
        return response.read().decode('utf-8')

def skip_trivia(text, pos):
    while pos < len(text):
        if text[pos].isspace():
            pos += 1
        elif text.startswith('--', pos):
            end = text.find('\n', pos)
            pos = len(text) if end < 0 else end + 1
        elif text.startswith('/-', pos):
            depth = 1
            pos += 2
            while depth:
                if pos >= len(text):
                    raise ValueError('unterminated block comment')
                if text.startswith('/-', pos):
                    depth += 1
                    pos += 2
                elif text.startswith('-/', pos):
                    depth -= 1
                    pos += 2
                else:
                    pos += 1
        else:
            return pos
    return pos

def port(text):
    pos = skip_trivia(text, 0)
    if re.match(r'module\b', text[pos:]):
        return text
    spans = []
    while re.match(r'import\b', text[pos:]):
        end = text.find('\n', pos)
        end = len(text) if end < 0 else end + 1
        line = text[pos:end]
        if not re.fullmatch(r'import\s+[A-Za-z_][A-Za-z0-9_.\x27]*(?:\s*--[^\n]*)?\s*', line):
            raise ValueError('unexpected import syntax: ' + repr(line))
        spans.append((pos, end))
        pos = skip_trivia(text, end)
    end = spans[-1][1] if spans else 0
    imports = ''.join('public ' + text[a:b] for a, b in spans)
    comments = text[:end]
    for a, b in reversed(spans):
        comments = comments[:a] + comments[b:]
    body = text[end:]
    header = ('module\n\n' + imports + '\n' + comments.strip() + '\n\n'
              '-- Module-system port for Palomar; mathematical bodies retained.\n'
              'set_option backward.privateInPublic true\n'
              'set_option backward.privateInPublic.warn false\n'
              'set_option backward.proofsInPublic true\n\n'
              '@[expose] public section\n')
    return header + body

paths = subprocess.check_output(['git', 'ls-files', '-z', '*.lean']).decode().split('\0')
changed = []
for name in paths:
    if not name:
        continue
    path = Path(name)
    if path.is_symlink():
        raise ValueError('Lean symlink: ' + name)
    text = path.read_text(encoding='utf-8')
    # Initial Challenge payload uses escaped Unicode so the transport is ASCII.
    if name == 'Challenge.lean':
        text = re.sub(r'\\u([0-9a-fA-F]{4})', lambda m: chr(int(m.group(1), 16)), text)
    result = text if path.name == 'lakefile.lean' else port(text)
    if len(result.splitlines()) > 10000:
        raise ValueError('source exceeds 10000 lines: ' + name)
    if result != path.read_text(encoding='utf-8'):
        path.write_text(result, encoding='utf-8')
        changed.append(name)
    if re.search(r'\b(elab|macro|run_cmd|initialize)\b', result):
        print('METAPROGRAMMING REVIEW:', name)

upstream_manifest = json.loads(fetch(f'https://raw.githubusercontent.com/leanprover-community/mathlib4/{MATHLIB}/lake-manifest.json'))
upstream_toolchain = fetch(f'https://raw.githubusercontent.com/leanprover-community/mathlib4/{MATHLIB}/lean-toolchain').strip()
assert upstream_toolchain == Path('lean-toolchain').read_text().strip(), upstream_toolchain
packages = [dict(p, inherited=True) for p in upstream_manifest['packages']]
mathlib = {'url': 'https://github.com/leanprover-community/mathlib4.git', 'type': 'git',
           'subDir': None, 'scope': '', 'rev': MATHLIB, 'name': 'mathlib',
           'manifestFile': 'lake-manifest.json', 'inputRev': MATHLIB,
           'inherited': False, 'configFile': 'lakefile.lean'}
manifest = {'version': upstream_manifest['version'], 'packagesDir': '.lake/packages',
            'packages': [mathlib] + packages, 'name': 'RequestProject',
            'lakeDir': '.lake', 'fixedToolchain': False}
Path('lake-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
license_text = fetch(f'https://raw.githubusercontent.com/openai/math/{UPSTREAM}/LICENSE')
blob = b'blob ' + str(len(license_text.encode())).encode() + b'\0' + license_text.encode()
assert hashlib.sha1(blob).hexdigest() == '261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64'
if Path('LICENSE').exists() and Path('LICENSE').read_text() != license_text:
    raise ValueError('refusing to overwrite a different license')
Path('LICENSE').write_text(license_text)
print(json.dumps({'ported_files': len(changed), 'files': changed}, indent=2))
