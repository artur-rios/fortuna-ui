#!/usr/bin/env bash
# The Check generated workflow's bindings-drift job (check-generated.yml, AF-05): the FFI bindings and the
# route table are both derived from the vendored header, so regenerating them must be a no-op on a clean
# tree. A difference means somebody edited generated code by hand, which is exactly what BR-36 forbids. Run
# from anywhere; it works from the repository's root, which must be a git checkout.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# shellcheck source=ci/flutter-env.sh
source ci/flutter-env.sh

flutter pub get

dart run tool/generate_bindings.dart

if ! git diff --quiet -- lib/core/bindings; then
  echo "ci/bindings-drift.sh: The committed FFI bindings differ from what regeneration produces." >&2
  echo "Run 'dart run tool/generate_bindings.dart' and commit the result." >&2
  echo "Never hand-edit lib/core/bindings (IR-10, FR-DA-05, BR-36)." >&2
  git diff --stat -- lib/core/bindings >&2
  exit 1
fi
echo "FFI bindings are in sync with native/include/fortuna_core.h."
