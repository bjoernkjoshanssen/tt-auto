#!/usr/bin/env python3
"""Non-executing checks for this repository's Palomar submission surface.

Checks the complete tracked snapshot, not just the imported proof files.
This is a local preflight, not a replacement for Palomar's verifier.
"""
from __future__ import annotations
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
THEOREMS = [
    'OAI.TuringRigidity.TwoConeMain.cones_orderIso_iff',
    'OAI.TuringRigidity.TwoConeMain.cone_iso_apply_val',
]
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
COMPILED = {'.olean', '.ilean', '.a', '.bc', '.dll', '.dylib', '.o', '.obj', '.so', '.trace'}


def first_token(text: str) -> str:
    i = 0
    while i < len(text):
        if text[i].isspace(): i += 1; continue
        if text.startswith('--', i):
            j = text.find('\n', i); i = len(text) if j < 0 else j + 1; continue
        if text.startswith('/--', i) or text.startswith('/-!', i):
            return 'documentation-before-module'
        if text.startswith('/-', i):
            depth = 1; i += 2
            while i < len(text) and depth:
                if text.startswith('/-', i): depth += 1; i += 2
                elif text.startswith('-/', i): depth -= 1; i += 2
                else: i += 1
            if depth: return 'unclosed-comment'
            continue
        m = re.match(r'[A-Za-z_][A-Za-z_0-9]*', text[i:])
        return m.group(0) if m else text[i:i+20]
    return ''


def main() -> None:
    errors = []
    count, size = 0, 0
    largest = (0, '')
    entries = subprocess.check_output(['git', 'ls-files', '--stage', '-z'], cwd=ROOT).split(b'\0')
    for entry in entries:
        if not entry: continue
        info, name = entry.split(b'\t', 1)
        mode = info.split()[0].decode()
        rel = Path(name.decode())
        if any(part in ('.git', '.lake') for part in rel.parts): continue
        path = ROOT / rel
        if mode == '160000': errors.append(f'{rel}: submodules are not allowed'); continue
        if path.is_symlink():
            if path.suffix == '.lean': errors.append(f'{rel}: Lean symlink refused')
            continue
        data = path.read_bytes(); size += len(data)
        if data.startswith(b'version https://git-lfs.github.com/spec/v1'):
            errors.append(f'{rel}: Git LFS pointer refused')
        if path.suffix in COMPILED or '.olean.' in path.name:
            errors.append(f'{rel}: compiled artifact outside .lake')
        if path.suffix != '.lean': continue
        count += 1
        lines = data.count(b'\n') + int(bool(data) and not data.endswith(b'\n'))
        largest = max(largest, (lines, str(rel)))
        if lines > 10000: errors.append(f'{rel}: {lines} lines exceeds 10000')
        try: text = data.decode('utf-8-sig')
        except UnicodeDecodeError:
            errors.append(f'{rel}: invalid UTF-8'); continue
        if path.name != 'lakefile.lean' and first_token(text) != 'module':
            errors.append(f'{rel}: missing module header before documentation/declarations')
        if rel == Path('Challenge.lean'):
            if lines > 1000 or len(data) > 100 * 1024:
                errors.append('Challenge exceeds the 1000-line / 100-KiB hard limit')
            if lines > 300 or len(data) > 32 * 1024:
                print('WARNING: Challenge exceeds Palomar preferred review size')
            imports = re.findall(r'(?m)^(?:public\s+)?(?:meta\s+)?import\s+([^\n]+)', text)
            for item in imports:
                for module in item.split('--')[0].split():
                    if not (module == 'Mathlib' or module.startswith('Mathlib.')):
                        errors.append(f'Challenge import is not Mathlib-only: {module}')
            print(f'Challenge: {lines} lines, {len(data)} bytes')
    if size > 500 * 1024 * 1024: errors.append('Tracked repository exceeds 500 MiB')
    configs = [p for p in ('lakefile.toml', 'lakefile.lean') if (ROOT / p).is_file()]
    if len(configs) != 1: errors.append('Expected exactly one Lake configuration')
    config = json.loads((ROOT / 'comparator.json').read_text())
    required = {'challenge_module', 'solution_module', 'theorem_names', 'permitted_axioms'}
    if not required <= config.keys(): errors.append('Missing required Comparator fields')
    if set(config) - required - {'definition_names', 'enable_nanoda'}:
        errors.append('Unsupported Comparator fields')
    if config.get('challenge_module') != 'Challenge' or config.get('solution_module') != 'Solution':
        errors.append('Unexpected Challenge/Solution modules')
    if config.get('theorem_names') != THEOREMS: errors.append('Unexpected advertised theorems')
    if set(config.get('permitted_axioms', [])) != ALLOWED: errors.append('Unexpected permitted axioms')
    manifest = json.loads((ROOT / 'lake-manifest.json').read_text())
    for package in manifest['packages']:
        if package.get('type') != 'git': errors.append(f"Non-Git dependency needs manual audit: {package['name']}"); continue
        if not re.fullmatch(r'[0-9a-f]{40}', package.get('rev', '')):
            errors.append(f"Dependency is not pinned: {package['name']}")
        if not re.fullmatch(r'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', package.get('url', '')):
            errors.append(f"Unexpected dependency URL: {package['name']}")
    toolchain = (ROOT / 'lean-toolchain').read_text().strip()
    m = re.fullmatch(r'leanprover/lean4:v(\d+)\.(\d+)\.(\d+)(?:-rc(\d+))?', toolchain)
    if not m or tuple(map(int, m.groups()[:3])) + (int(m.group(4)) if m.group(4) else 10**9,) < (4, 35, 0, 2):
        errors.append('Toolchain is older than the checked Palomar minimum v4.35.0-rc2')
    dep_toolchain = ROOT / '.lake/packages/mathlib/lean-toolchain'
    if dep_toolchain.exists() and dep_toolchain.read_text().strip() != toolchain:
        errors.append('Project and pinned Mathlib toolchains differ')
    if not (ROOT / 'LICENSE').is_file(): errors.append('Missing root LICENSE')
    else:
        license_text = (ROOT / 'LICENSE').read_text()
        if 'Apache License' not in license_text or 'Version 2.0, January 2004' not in license_text:
            errors.append('Expected Apache-2.0 license text')
    print(f'Scanned {count} tracked Lean files; largest: {largest[1]} ({largest[0]} lines).')
    print(f'Tracked regular-file size: {size} bytes.')
    if errors:
        print('\n'.join('ERROR: ' + error for error in errors), file=sys.stderr)
        raise SystemExit(1)
    print('Palomar source/configuration preflight passed.')

if __name__ == '__main__': main()
