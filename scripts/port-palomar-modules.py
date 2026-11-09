#!/usr/bin/env python3
"""Idempotent source-only port following Lean's documented module recipe.

Run on the dedicated PR branch. Does not alter mathematical statements or
proof bodies. Existing explicit private modifiers and attribution are retained.
The two backward compatibility options preserve pre-module elaboration; they
are not axioms and do not bypass kernel checking. Validation is separate.
"""
from __future__ import annotations
import base64
import hashlib
from pathlib import Path
import re
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parent.parent

def masked(text: str) -> str:
    """Mask comments and strings, retaining newlines and character positions."""
    out = list(text)
    i, depth, string = 0, 0, False
    while i < len(text):
        if depth:
            if text.startswith('/-', i):
                out[i:i+2] = '  '; depth += 1; i += 2
            elif text.startswith('-/', i):
                out[i:i+2] = '  '; depth -= 1; i += 2
            else:
                if text[i] != '\n': out[i] = ' '
                i += 1
        elif string:
            if text[i] == '\\' and i + 1 < len(text):
                out[i:i+2] = '  '; i += 2
            else:
                if text[i] == '"': string = False
                if text[i] != '\n': out[i] = ' '
                i += 1
        elif text.startswith('/-', i):
            out[i:i+2] = '  '; depth = 1; i += 2
        elif text.startswith('--', i):
            j = text.find('\n', i)
            if j < 0: j = len(text)
            out[i:j] = ' ' * (j-i); i = j
        elif text[i] == '"':
            out[i] = ' '; string = True; i += 1
        else:
            i += 1
    if depth or string:
        raise ValueError('Unterminated comment or string')
    return ''.join(out)

def migrate(path: Path) -> bool:
    if path.is_symlink(): raise ValueError(f'Symlink: {path}')
    text = path.read_text(encoding='utf-8-sig')
    code = masked(text)
    if re.match(r'\s*module\b', code): return False
    imports = list(re.finditer(r'(?m)^import[ \t]+[^\n]*', code))
    header = []
    body = text
    for m in reversed(imports):
        raw = text[m.start():m.end()]
        header.insert(0, 'public ' + raw.rstrip())
        body = body[:m.start()] + body[m.end():]
    notice = '-- Palomar port: module visibility updated; mathematical declarations retained.\n'
    options = ('set_option backward.privateInPublic true\n'
               'set_option backward.proofsInPublic true\n\n'
               '@[expose] public section\n\n')
    result = 'module\n\n' + '\n'.join(header) + '\n\n' + notice + options + body.lstrip('\n')
    if len(result.splitlines()) > 10000:
        raise ValueError(f'{path}: source exceeds Palomar line limit; split manually')
    path.write_text(result, encoding='utf-8')
    return True

def main() -> None:
    files = subprocess.check_output(['git', 'ls-files', '-z', '*.lean'], cwd=ROOT).split(b'\0')
    changed = []
    for name in files:
        if not name: continue
        path = ROOT / name.decode()
        if any(p in ('.git', '.lake') for p in path.relative_to(ROOT).parts): continue
        if path.name == 'lakefile.lean': continue
        if migrate(path): changed.append(str(path.relative_to(ROOT)))
    # Restore the upstream Apache-2.0 terms, fetched by immutable Git blob ID.
    # This is text, not downloaded executable code; verify the Git object hash.
    license_path = ROOT / 'LICENSE'
    if not license_path.exists():
        import json
        sha = '261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64'
        url = f'https://api.github.com/repos/openai/math/git/blobs/{sha}'
        req = urllib.request.Request(url, headers={'User-Agent': 'tt-auto-palomar-port'})
        with urllib.request.urlopen(req, timeout=30) as response:
            blob = json.load(response)
        content = base64.b64decode(blob['content'])
        digest = hashlib.sha1(b'blob ' + str(len(content)).encode() + b'\0' + content).hexdigest()
        if digest != sha: raise ValueError('Upstream license hash mismatch')
        license_path.write_bytes(content)
    print(f'Ported {len(changed)} Lean files to the module system.')
    print('\n'.join(changed[:15]))

if __name__ == '__main__': main()
