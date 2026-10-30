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

flutter test --coverage
