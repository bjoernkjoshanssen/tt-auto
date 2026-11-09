#!/usr/bin/env python3
"""Reject every non-permitted axiom in Lean's transitive audit output."""
from pathlib import Path
import re
import sys

ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
TARGET = 'OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso'
if len(sys.argv) < 2:
    raise SystemExit('Usage: check-axioms.py REPORT [REPORT ...]')
seen = set()
for filename in sys.argv[1:]:
    text = Path(filename).read_text(encoding='utf-8')
    matches = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", text, re.S)
    if not matches:
        raise SystemExit(f'{filename}: no axiom reports found')
    for name, entries in matches:
        axioms = {item.strip() for item in entries.split(',') if item.strip()}
        if axioms - ALLOWED:
            raise SystemExit(f'{filename}: {name} uses forbidden axioms {sorted(axioms - ALLOWED)}')
        seen.add(name)
if TARGET not in seen:
    raise SystemExit('The advertised theorem was not included in the audit')
print(f'{len(seen)} distinct declarations audited; only the three permitted axioms occur.')
