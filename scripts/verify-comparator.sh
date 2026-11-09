#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Mirrors Palomar's documented toolchain-bundled Comparator invocation.
# No verifier binary or proof is taken from the submitted repository.
for command in bwrap lake lean python3; do
  command -v "$command" >/dev/null || { echo "Missing required command: $command" >&2; exit 1; }
done
prefix=$(lean --print-prefix)
for tool in lake leanexport leanchecker nanoda_bin con-ron; do
  test -x "$prefix/bin/$tool" || { echo "Toolchain does not bundle $tool" >&2; exit 1; }
done
config=$(mktemp "${TMPDIR:-/tmp}/tt-auto-comparator.XXXXXX.json")
trap 'rm -f "$config"' EXIT
python3 - comparator.json "$config" "$prefix" <<'PY'
import json
from pathlib import Path
import sys
source, destination, prefix = sys.argv[1:]
config = json.loads(Path(source).read_text())
if 'external_kernels' in config:
    raise SystemExit('external_kernels is not an allowed submitter configuration field')
config.pop('enable_nanoda', None)
config['external_kernels'] = {
    'nanoda': [f'{prefix}/bin/nanoda_bin'],
    'con-ron': [f'{prefix}/bin/con-ron'],
}
Path(destination).write_text(json.dumps(config, indent=2) + '\n')
PY
lake comparator --config "$config"
