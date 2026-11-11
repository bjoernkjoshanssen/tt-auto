#!/usr/bin/env python3
"""Validate metadata against the immutable upstream v0.4 schema and local policy.

Requires PyYAML and jsonschema. The schema is fetched as data, checked against
its Git blob hash, and cached below .lake; no downloaded code is executed.
"""
from __future__ import annotations
import base64
import hashlib
import json
from pathlib import Path
import re
import sys
import urllib.request
import yaml
from jsonschema import Draft7Validator

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_BLOB = '19f4a46a1bc0e4798dca7bcb7ed57281b1c8c996'
LICENSE_BLOB = '261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64'
THEOREMS = [
    'OAI.TuringRigidity.TwoConeMain.cones_orderIso_iff',
    'OAI.TuringRigidity.TwoConeMain.cone_iso_apply_val',
]
AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}


def git_hash(data: bytes) -> str:
    return hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()


def schema_data() -> dict:
    cache = ROOT / '.lake' / ('formalization-schema-' + SCHEMA_BLOB + '.json')
    if cache.exists():
        data = cache.read_bytes()
    else:
        request = urllib.request.Request(
            'https://api.github.com/repos/mathlib-initiative/formalization.yaml/git/blobs/' + SCHEMA_BLOB,
            headers={'User-Agent': 'tt-auto-metadata-validator'})
        with urllib.request.urlopen(request, timeout=30) as response:
            blob = json.load(response)
        data = base64.b64decode(blob['content'])
    if git_hash(data) != SCHEMA_BLOB: raise ValueError('Metadata schema hash mismatch')
    cache.parent.mkdir(parents=True, exist_ok=True)
    cache.write_bytes(data)
    return json.loads(data)


def main() -> None:
    text = (ROOT / 'formalization.yaml').read_text(encoding='utf-8')
    meta = yaml.safe_load(text)
    errors = [f"{'.'.join(map(str, error.path))}: {error.message}"
              for error in Draft7Validator(schema_data()).iter_errors(meta)]
    if not isinstance(meta, dict): raise ValueError('Metadata is not a mapping')
    project = meta.get('project', {})
    for field in ('name', 'description', 'authors', 'responsible_maintainers', 'license'):
        if not project.get(field): errors.append(f'project.{field} must be nonempty')
    if project.get('license') != 'Apache-2.0': errors.append('Unexpected root license')
    if git_hash((ROOT / 'LICENSE').read_bytes()) != LICENSE_BLOB:
        errors.append('LICENSE differs from the verified upstream Apache-2.0 text')
    if 'TEMPLATE' in text: errors.append('Unfilled template sentinel')
    classification = meta.get('classification', {})
    if not 1 <= len(classification.get('arxiv', [])) <= 2:
        errors.append('Expected 1-2 arXiv subjects')
    codes = classification.get('msc2020', [])
    if not 1 <= len(codes) <= 8 or any(not re.fullmatch(r'\d{2}[A-Z]\d{2}', x) for x in codes):
        errors.append('Expected 1-8 MSC2020 identifiers')
    sources = meta.get('sources', [])
    rels = {'formalizes', 'adapts', 'independently-proves', 'background', 'other'}
    if not sources or any(not s.get('title') or s.get('relationship') not in rels for s in sources):
        errors.append('Each source needs a title and canonical relationship')
    originals = [s for s in sources if s.get('type') == 'original-proof']
    if originals:
        if any(s.get('relationship') not in {'background', 'other'} for s in sources):
            errors.append('Original-proof sources require background/other relationships')
    elif not any(s.get('relationship') in {'formalizes', 'adapts', 'independently-proves'} for s in sources):
        errors.append('No result origin recorded')
    status = meta.get('status', {})
    if set(status.get('axioms', [])) != AXIOMS: errors.append('Unexpected axiom declaration')
    for key in ('sorry_count', 'sorry_in_definitions'):
        if status.get(key) != 0: errors.append(f'status.{key} is not zero for these completed proofs')
    results = status.get('main_results', [])
    if [r.get('declaration') for r in results] != THEOREMS:
        errors.append('Metadata main results differ from the selected pairwise-rigidity targets')
    comparator = json.loads((ROOT / 'comparator.json').read_text())
    if comparator.get('theorem_names') != THEOREMS:
        errors.append('Comparator targets differ from metadata main results')
    for result in results:
        if result.get('sorry_count') != 0 or set(result.get('axioms', [])) != AXIOMS:
            errors.append(f"Unexpected proof status for {result.get('declaration')}")
        if result.get('comparator_config') != 'comparator.json':
            errors.append('Unexpected per-result Comparator configuration')
    methods = meta.get('automation', {}).get('methods', [])
    if not any('ChatGPT 6 Pro' in method.get('models', []) for method in methods):
        errors.append('Missing requested ChatGPT 6 Pro attribution')
    if not meta.get('review', {}).get('notes'): errors.append('Missing review limitations')
    if errors:
        print('\n'.join('ERROR: ' + x for x in errors), file=sys.stderr)
        raise SystemExit(1)
    print('formalization.yaml passes the pinned upstream v0.4 schema and submission preflight.')
    print('License: exact upstream Apache-2.0 text. Compared theorems: ' + ', '.join(THEOREMS))

if __name__ == '__main__': main()
