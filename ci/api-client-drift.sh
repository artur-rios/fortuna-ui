#!/usr/bin/env bash
# The Check generated workflow's api-client-drift job (check-generated.yml, IR-11, IR-12): regenerate the API
# client from api/fortuna.json and fail if that differs from what is committed. Run from anywhere; it works
# from the repository's root, which must be a git checkout.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# shellcheck source=ci/flutter-env.sh
source ci/flutter-env.sh

flutter pub get

dart run tool/generate_api_client.dart

if ! git diff --quiet -- packages/fortuna_api_client api; then
  echo "ci/api-client-drift.sh: The committed API client differs from what regeneration produces." >&2
  echo "Run 'dart run tool/generate_api_client.dart' and commit the result." >&2
  echo "Never hand-edit packages/fortuna_api_client/lib (IR-09, BR-36)." >&2
  git diff --stat -- packages/fortuna_api_client api >&2
  exit 1
fi
echo "API client is in sync with api/fortuna.json."
