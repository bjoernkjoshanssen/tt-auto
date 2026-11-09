#!/usr/bin/env python3
"""Offline preflight for this root-layout Palomar submission (not a verifier)."""
from pathlib import Path
import json
import re
import subprocess
import sys
import tomllib
import urllib.parse
import yaml

ROOT = Path(__file__).resolve().parent.parent
TARGET = 'OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso'
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}

class UniqueLoader(yaml.SafeLoader):
    pass

def unique_mapping(loader, node, deep=False):
    result = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key == '<<' or key in result:
            raise ValueError(f'duplicate or merge YAML key: {key}')
        result[key] = loader.construct_object(value_node, deep=deep)
    return result
UniqueLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_mapping)

def require(condition, message):
    if not condition:
        raise ValueError(message)

def first_token(text):
    pos = 0
    while pos < len(text):
        if text[pos].isspace():
            pos += 1
        elif text.startswith('--', pos):
            end = text.find('\n', pos)
            pos = len(text) if end < 0 else end + 1
        elif text.startswith('/-', pos) and not text.startswith(('/-!', '/--'), pos):
            depth = 1
            pos += 2
            while depth:
                require(pos < len(text), 'unterminated comment')
                if text.startswith('/-', pos):
                    depth += 1; pos += 2
                elif text.startswith('-/', pos):
                    depth -= 1; pos += 2
                else:
                    pos += 1
        else:
            return text[pos:]
    return ''

def main():
    config = json.loads((ROOT / 'comparator.json').read_text())
    require(set(config) <= {'challenge_module', 'solution_module', 'theorem_names',
                           'definition_names', 'permitted_axioms', 'enable_nanoda'},
            'unexpected Comparator key')
    require(config['challenge_module'] == 'Challenge' and config['solution_module'] == 'Solution',
            'unexpected statement modules')
    require(config['theorem_names'] == [TARGET], 'the selected theorem changed')
    require(set(config['permitted_axioms']) == ALLOWED_AXIOMS, 'unexpected allowed axioms')
    data = yaml.load((ROOT / 'formalization.yaml').read_text(), Loader=UniqueLoader)
    require(data['version'] == 'v0.4', 'metadata must use v0.4')
    project = data['project']
    for field in ('name', 'description'):
        require(isinstance(project[field], str) and project[field].strip(), f'missing {field}')
    for field in ('authors', 'responsible_maintainers'):
        require(isinstance(project[field], list) and project[field]
                and all(isinstance(x, str) and x.strip() for x in project[field]), f'invalid {field}')
    require(project['license'] == 'Apache-2.0', 'license metadata mismatch')
    licenses = [p for p in ROOT.iterdir() if re.fullmatch(
        r'(LICENSE|LICENCE|COPYING|UNLICENSE|OFL)(\.(md|markdown|txt))?', p.name, re.I)]
    require(len(licenses) == 1 and licenses[0].name == 'LICENSE', 'ambiguous root license')
    require('Apache License' in licenses[0].read_text() and
            'Version 2.0, January 2004' in licenses[0].read_text(), 'unexpected license text')
    require(data['classification']['arxiv'] == ['math.LO'], 'unexpected arXiv classification')
    require(set(data['classification']['msc2020']) <= {'03D28', '03B35', '03E40'}, 'unexpected MSC code')
    require(data['sources'] and all(s.get('title') and s.get('relationship') in
            {'formalizes', 'adapts', 'independently-proves', 'background', 'other'}
            for s in data['sources']), 'invalid sources')
    require(any(s['relationship'] in {'formalizes', 'adapts', 'independently-proves'}
                for s in data['sources']), 'source-based provenance missing')
    require(not any(s.get('type') == 'original-proof' for s in data['sources']),
            'do not mix source-based and original-proof modes')
    require(data['automation']['methods'] and all(m.get('method') for m in data['automation']['methods']),
            'automation disclosure missing')
    require(data['review'].get('status'), 'review status missing')
    require(len(list(ROOT.glob('lakefile.*'))) == 1 and (ROOT / 'lakefile.toml').is_file(),
            'expected exactly one Lakefile')
    lake = tomllib.loads((ROOT / 'lakefile.toml').read_text())
    manifest = json.loads((ROOT / 'lake-manifest.json').read_text())
    for package in manifest['packages']:
        require(package['type'] == 'git', 'unexpected non-Git dependency')
        require(re.fullmatch('[0-9a-f]{40}', package['rev']), 'unpinned dependency')
        url = urllib.parse.urlparse(package['url'])
        require(url.scheme == 'https' and url.netloc == 'github.com' and
                not url.query and not url.fragment and not url.username, 'unsafe dependency URL')
    mathlib = next(p for p in manifest['packages'] if p['name'] == 'mathlib')
    require(lake['require'][0]['rev'] == mathlib['rev'], 'Lake/manifest pin mismatch')
    toolchain = (ROOT / 'lean-toolchain').read_text().strip()
    require(toolchain == 'leanprover/lean4:v4.35.0-rc2', 'unexpected toolchain')
    dependency_toolchain = ROOT / '.lake/packages/mathlib/lean-toolchain'
    if dependency_toolchain.exists():
        require(dependency_toolchain.read_text().strip() == toolchain, 'Mathlib toolchain mismatch')
    tracked = subprocess.run(['git', 'ls-files', '-z'], cwd=ROOT, capture_output=True, check=False)
    files = ([ROOT / p for p in tracked.stdout.decode().split('\0') if p] if tracked.returncode == 0
             else [p for p in ROOT.rglob('*') if p.is_file() and '.git' not in p.parts and '.lake' not in p.parts])
    lean_count = 0
    max_lines = 0
    for path in files:
        require(not path.is_dir(), f'possible Git submodule: {path}')
        if path.is_symlink():
            require(path.suffix != '.lean', f'Lean symlink: {path}')
            continue
        require(path.suffix not in {'.olean', '.ilean', '.a', '.bc', '.dll', '.dylib',
                                    '.o', '.obj', '.so', '.trace'}, f'compiled artifact: {path}')
        content = path.read_bytes()
        require(not content.startswith(b'version https://git-lfs.github.com/spec/v1'), f'LFS pointer: {path}')
        if path.suffix != '.lean':
            continue
        lines = content.count(b'\n') + int(bool(content) and not content.endswith(b'\n'))
        require(lines <= 10000, f'oversized Lean source: {path}')
        max_lines = max(max_lines, lines)
        if path.name != 'lakefile.lean':
            require(re.match(r'module\b', first_token(content.decode('utf-8'))), f'module header missing: {path}')
        lean_count += 1
    challenge = (ROOT / 'Challenge.lean').read_bytes()
    require(len(challenge) <= 102400 and challenge.count(b'\n') <= 1000, 'Challenge too large')
    imports = re.findall(r'^(?:public\s+)?import\s+([^\n]+)', challenge.decode(), re.M)
    require(imports == ['Mathlib'], 'Challenge must import only canonical Mathlib')
    require('Challenge' not in re.findall(r'^(?:public\s+)?import\s+([^\n]+)',
            (ROOT / 'Solution.lean').read_text(), re.M), 'Solution must not import Challenge')
    print(json.dumps({'lean_sources': lean_count, 'maximum_lines': max_lines,
                      'challenge_bytes': len(challenge), 'theorem': TARGET,
                      'toolchain': toolchain, 'mathlib': mathlib['rev']}, indent=2))

if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, yaml.YAMLError) as error:
        print(f'Palomar preflight failed: {error}', file=sys.stderr)
        raise SystemExit(1)
