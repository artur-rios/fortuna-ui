# Contributing

One use case = one branch = one issue = one pull request. The full process — branch naming, the
issue status lifecycle, the four approval gates, the testing gate, and the Definition of Done — is
in the
[Development Workflow Document](docs/requirements/Development%20Workflow%20Document.md). Work
branches are cut from and merged into `develop`; see the [branching model](#branching-model) below.

## Prerequisites

The **Flutter SDK**, stable channel, at the latest stable release — with the desktop toolchain for
whichever platform you are building. The version policy, and why no number is pinned here, is in the
[Technology Stack Document](docs/requirements/Technology%20Stack%20Document.md) §1.1.

```bash
git clone https://github.com/artur-rios/fortuna-ui.git
cd fortuna-ui
flutter pub get
```

## Generated code

The generated API client is committed, so a clean clone needs no generation step. Regenerate it only
after taking a new API contract into `api/fortuna.json`:

```bash
dart run tool/generate_api_client.dart
```

The FFI bindings have their own generator, which reads the Fortuna core's C header vendored from
`fortuna-api` at `native/include/fortuna_core.h`, and refuses to run, saying why, when that header is
absent. See [native/README.md](native/README.md).

```bash
dart run tool/generate_bindings.dart
```

Never hand-edit the generated code. The **Check generated** workflow regenerates the API client and
the bindings and fails on any difference from what is committed, and fails when the vendored header
differs from the one `fortuna-api` publishes.

## Testing

The suite described in the
[Testing Specification Document](docs/requirements/Testing%20Specification%20Document.md) runs with:

```bash
flutter analyze
flutter test
```

An analyzer failure is a failure. Integration tests belong in `integration_test/` and are invoked
deliberately, so the fast suite stays fast:

```bash
flutter test integration_test -d windows
```

The suite covers **unit**, **widget** and **integration** tests. There is no numeric coverage floor:
the standard is that every use case's main flow and each of its `AF-xx` alternative flows has a test
that names it. Every use case ships with its tests before its pull request is opened.

CI also verifies formatting and the boundary rules on every pull request into `develop` and `main`:

```bash
dart format --output=none --set-exit-if-changed lib test tool
dart run tool/check_boundaries.dart
```

## Branching model

```
feature/<name> ─┐
fix/<name> ─────┴─▶ develop ──▶ release/x.y.z ──▶ main  (tag vx.y.z)
```

| Branch | Cut from | Merges into | How |
|---|---|---|---|
| `feature/<name>`, `fix/<name>` | `develop` | `develop` | Pull request, squash or merge. The branch is deleted on merge. |
| `release/x.y.z` | `develop` | `main` | Pull request. **Never merged by hand** — see below. |
| `develop`, `main` | — | — | Protected: no direct pushes, no force pushes, no deletion. |

Names are lowercase: letters, digits, `.`, `_` and `-`. A `release/` branch is a snapshot of
`develop` and carries no commits of its own: a fix for a release lands on `develop` through a
`fix/` branch and a new release branch is cut.

The **Branch Policy** workflow checks all of this on every pull request and is a required check
on `develop` and `main`.

## Commits and the changelog

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/) with a lowercase
subject, e.g. `feat: record a transfer (UC-21)` or `fix: re-vendor core header from fortuna-api`.

Record every change a user would notice under `## [Unreleased]` in [CHANGELOG.md](./CHANGELOG.md),
in the same pull request that makes it.

## Versioning

The application follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html). A release is
numbered `<major>.<minor>.<patch>`, and each part is measured against what users, operators and
existing installations depend on:

- **Major** — a change someone has to act on: a supported platform dropped; a desktop offline
  installation whose data the new version cannot open or migrate; a build-time setting
  (`--dart-define` or Docker build argument) removed or renamed; a feature removed; or a
  requirement for a Fortuna API contract or core library that a deployment still running the
  previous one does not provide.
- **Minor** — a backward-compatible addition: a new screen or feature, a new optional setting, or
  support for something the API added while still working with the contract it replaces.
- **Patch** — a fix that changes nothing anyone depends on: a bug fix, a layout or wording
  correction, or a dependency upgrade.

The version is set in two places that must agree. `version: x.y.z+n` in `pubspec.yaml` is what
every build embeds — the web build's `version.json`, the Windows executable's version resource
and the Android package's version name and code; the build number `n` only ever increases, because
Android refuses to install a package over one with a higher number. The release branch `release/x.y.z` names the release:
Jenkins takes the number from the branch name, tags the deployed image `x.y.z-<short sha>` (the
version the yggdrasil console shows) and creates the tag `vx.y.z` when the release merges. The
Branch Policy check rejects a release branch whose version already has a tag.

## Releasing

1. Because a release branch carries no commits of its own, finalize the changelog on `develop`
   first: in a `feature/` branch, set `version:` in `pubspec.yaml` to `x.y.z+n` with the next
   build number, rename `## [Unreleased]` in [CHANGELOG.md](./CHANGELOG.md) to
   `## [x.y.z] - <yyyy-mm-dd>` above a fresh, empty `## [Unreleased]`, update the links at the
   bottom, and merge it into `develop`.
2. `git switch develop && git pull && git switch -c release/1.4.0 && git push -u origin release/1.4.0`
   — Jenkins deploys the branch to **homologation**.
3. Open a pull request `release/1.4.0 → main`.
4. When every GitHub check on the pull request passes, Jenkins deploys to **production**. On
   success it sets the `deploy/production` status, merges the pull request with a merge commit,
   creates the tag and GitHub release `v1.4.0`, and deletes the release branch.
5. If the production deploy fails, Jenkins rolls back to the previous image and the pull request
   stays open. Fix on `develop`, then cut a new release.

The **Build** workflow, which builds every target and uploads the artifacts, runs on `v*` tags and
can be started by hand.

Follow a release in the **yggdrasil console** (`https://yggdrasil.<domain>`, or the Android app).
The system card shows this application's version, commit, deploy time and health in each
environment.

The repository owner can bypass these rules. That is for emergencies, not for routine work.

## Where this is deployed from

Deployment is managed by [yggdrasil](https://github.com/artur-rios/yggdrasil). This repository is
the application `fortuna-ui` in its `catalog.yaml`, which is what gives it:
- its Jenkins deploy job
- its GitHub rulesets and required checks (the catalog's `checks`)
- its Prometheus scraping
- its place in the console

If a required check is renamed or added here, update the catalog entry, then run
`python github/rulesets.py fortuna-ui` in yggdrasil.
