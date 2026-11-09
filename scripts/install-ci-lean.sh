#!/usr/bin/env bash
# Install the exact official release. All download routes must match the
# same published digest before extraction. Linux x86_64 disposable CI only.
set -euo pipefail
cd "$(dirname "$0")/.."
test "$(uname -s)" = Linux
test "$(uname -m)" = x86_64
test "$(tr -d '\r\n' < lean-toolchain)" = leanprover/lean4:v4.35.0-rc2
: "${RUNNER_TEMP:?This helper is for the disposable CI runner}"
: "${GITHUB_PATH:?GitHub Actions path file is required}"
archive="$RUNNER_TEMP/lean-4.35.0-rc2-linux.tar.zst"
prefix="$RUNNER_TEMP/lean-4.35.0-rc2"
# Digest published by leanprover/lean4 for release asset 567981860.
sha=b67d0e0ba959fc74e186f1b44aebca32d6ecb6a28f8e9a029fc4e9f73398a049
verified=false
for url in \
  'https://api.github.com/repos/leanprover/lean4/releases/assets/567981860' \
  "https://github.com/leanprover/lean4/releases/download/v4.35.0-rc2/lean-4.35.0-rc2-linux.tar.zst?download=1&request=$(date +%s)" \
  'https://releases.lean-lang.org/lean4/v4.35.0-rc2/lean-4.35.0-rc2-linux.tar.zst'; do
  if curl --fail --location --retry 2 --retry-all-errors --connect-timeout 30 --max-time 600 \
      --proto '=https' --proto-redir '=https' -H 'Accept: application/octet-stream' \
      "$url" --output "$archive" && \
      printf '%s  %s\n' "$sha" "$archive" | sha256sum --check --strict; then
    verified=true
    break
  fi
  echo 'Download route failed or did not return the verified release; trying the next official route.' >&2
done
if test "$verified" != true; then
  echo 'Could not obtain the pinned, checksum-verified Lean release.' >&2
  exit 1
fi
mkdir -p "$prefix"
tar --zstd -xf "$archive" --strip-components=1 -C "$prefix"
printf '%s\n' "$prefix/bin" >> "$GITHUB_PATH"
"$prefix/bin/lean" --version
"$prefix/bin/lake" --version
