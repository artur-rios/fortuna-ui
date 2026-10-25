#!/usr/bin/env bash
# The Check generated workflow's header-drift job (check-generated.yml, UC-02 AF-04, IR-11): the C header
# vendored at native/include/fortuna_core.h and the one fortuna-api publishes must be identical. Run from
# anywhere; it works from the repository's root.
#
# The API is cloned (shallow, its default branch, as the workflow's checkout did) from FORTUNA_API_URL,
# default: GitHub's read-only mirror of fortuna-api, which is public. FORTUNA_API_DIR names a checkout that
# already exists and is used instead, without cloning (for a run by hand).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

VENDORED=native/include/fortuna_core.h
FORTUNA_API_URL=${FORTUNA_API_URL:-https://github.com/artur-rios/fortuna-api.git}

api_dir=${FORTUNA_API_DIR:-}
if [ -z "$api_dir" ]; then
  api_dir=$(mktemp -d)
  trap 'rm -rf "$api_dir"' EXIT
  git clone --quiet --depth 1 "$FORTUNA_API_URL" "$api_dir"
fi

PUBLISHED=$(find "$api_dir" -name 'fortuna_core.h' -not -path '*/.git/*' -print -quit)

# The "neither exists" branch is a guard for a repository state that no longer occurs, kept so the check
# explains itself rather than failing obscurely if the header were ever removed upstream.
if [ ! -f "$VENDORED" ] && [ -z "$PUBLISHED" ]; then
  echo "No C header on either side: nothing to diff."
  exit 0
fi

if [ ! -f "$VENDORED" ]; then
  echo "ci/header-drift.sh: The API publishes a C header but this repository has not vendored it." >&2
  echo "Copy $PUBLISHED to $VENDORED and run 'dart run tool/generate_bindings.dart'." >&2
  exit 1
fi

if [ -z "$PUBLISHED" ]; then
  echo "ci/header-drift.sh: A header is vendored here but the API publishes none." >&2
  exit 1
fi

if ! diff -u "$PUBLISHED" "$VENDORED"; then
  echo "ci/header-drift.sh: The vendored header differs from the one the API publishes." >&2
  echo "Re-copy it and run 'dart run tool/generate_bindings.dart' (IR-10, IR-11)." >&2
  exit 1
fi
echo "Vendored header matches the published one."
