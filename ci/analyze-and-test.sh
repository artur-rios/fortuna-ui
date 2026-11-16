#!/usr/bin/env bash
# The CI workflow's analyze-and-test job (ci.yml, IR-19): formatting, analysis, the boundary rules and the
# tests with coverage. Run from anywhere; it works from the repository's root. Coverage has no threshold, so
# it never fails the build; coverage/lcov.info is kept with the build (`archive` in yggdrasil.yml).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# shellcheck source=ci/flutter-env.sh
source ci/flutter-env.sh

flutter pub get

dart format --output=none --set-exit-if-changed lib test tool

# An analyzer failure is a failure (Development Workflow §4, Step 5).
flutter analyze

# IR-13 and IR-14. Enforced as a build step rather than an IDE plugin; see tool/boundary_rules.dart for why.
dart run tool/check_boundaries.dart

# The suite runs as four bundles side by side (tool/test_bundles.dart says why): `flutter test` compiles one entry
# point at a time whatever its concurrency, so one entry point per test file spent most of the step compiling and
# loading 100-odd files in a row. The concurrency is set, not left at half the agent's cores.
dart run tool/test_bundles.dart build/test-bundles 4
flutter test --coverage --concurrency 4 build/test-bundles
