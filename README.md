# Fortuna UI

Fortuna is a personal finance system that tracks a person's whole financial life — bank accounts,
credit cards, investments, expenses and earnings — in one place, and turns that history into tabular
views, charts and forward-looking projections. **This repository is the front end only:** a single
Flutter application that runs on the web, Windows, Linux and Android from one code base, and reads
and writes everything through the [Fortuna API](https://github.com/artur-rios/fortuna-api). The API
owns the domain, the money and the integrations; this application owns the experience.

> **Status:** specification complete, implementation not started.

## What it does

- **Signs the user in** — email and password, or Google, with two-factor authentication where the
  account has it, and a local account for desktop offline mode.
- **Shows holdings** — bank accounts, credit cards with their billing cycles and statements, and
  investments with their positions.
- **Records money movement** — expenses, earnings, transfers, installment purchases and recurring
  commitments.
- **Brings data in** — bank connections, synchronizations, Excel workbooks and statement PDFs, each
  followed to its per-row outcome.
- **Presents data as a spreadsheet** — a filterable, sortable, paginated grid, with the work done by
  the API.
- **Presents data as charts** — aggregations that can be tapped and descended into, all the way down
  to the individual transactions, and back out again.
- **Shows the future** — net position, cash-flow projections and committed obligations, always
  visually distinct from what actually happened.
- **Exports** — CSV, Excel and PDF, produced by the API and saved by the platform.
- **Honors data rights** — consent before anything reaches a third party, a complete export, and
  account erasure.
- **Runs offline on the desktop** — Windows and Linux installations ship the Fortuna core as a
  native library and call it in process, with no network and no server.

## What it doesn't do

- **It does not compute money.** Every balance, total, aggregation and projection is asked of the
  API. The client formats figures; it never derives them.
- **It does not own data.** There is no client-side database, and nothing is authoritative until the
  API has accepted it.
- **It does not parse or render files.** An import is uploaded whole; an export is produced by the
  API and merely saved.
- **It does not talk to external services.** Every integration is reached through the API — the one
  exception is Google, which issues a sign-in token the API exchanges.
- **It does not run on iOS or macOS.**
- **It does not work offline outside desktop offline mode.** A lost connection is reported, never
  disguised by a cache.

It also inherits every exclusion the API declares: it does not move money, give financial advice, do
tax filing, store bank credentials, or write back to any financial institution.

## Specifications

The project is specified before it is built. Start with the `initial/` documents for context, then
the `requirements/` documents for the normative detail.

| Document | What's in it |
|---|---|
| [Brainstorm](docs/initial/Brainstorm.md) | The original free-form notes this project grew from. |
| [Project Overview](docs/initial/Project%20Overview.md) | What the project is, who it's for, and how success is measured. |
| [Technology Stack](docs/initial/Technology%20Stack.md) | The informal stack decisions. |
| [Workflow](docs/initial/Workflow.md) | How one use case is delivered, step by step. |
| [Business Rules](docs/initial/Business%20Rules.md) | What the client owns, and the `BR-xx` rules. |
| [Vision Document](docs/requirements/Vision%20Document.md) | Stakeholders, positioning, and the `F-xx` features. |
| [System Requirements Document](docs/requirements/System%20Requirements%20Document.md) | The `FR-<AREA>-xx` and `NFR-xx` requirements, data model, screen surface, and traceability. |
| [Use Case Specification Document](docs/requirements/Use%20Case%20Specification%20Document.md) | The `UC-xx` use cases, their flows, and their `AF-xx` alternatives. |
| [Development Workflow Document](docs/requirements/Development%20Workflow%20Document.md) | The normative branch pattern, issue lifecycle, gates, and Definition of Done. |
| [Testing Specification Document](docs/requirements/Testing%20Specification%20Document.md) | How tests are written, named, and run. |
| [Technology Stack Document](docs/requirements/Technology%20Stack%20Document.md) | The single source of truth for every technology and version. |
| [Operations & Infrastructure Document](docs/requirements/Operations%20%26%20Infrastructure%20Document.md) | Layout, configuration, generation pipelines, CI, packaging, and the `IR-xx` platform requirements. |

## Installation

Prerequisites: the **Flutter SDK**, stable channel, at the latest stable release — with the desktop
toolchain for whichever platform you are building. The version policy, and why no number is pinned
here, is in the
[Technology Stack Document](docs/requirements/Technology%20Stack%20Document.md) §1.1.

```bash
git clone https://github.com/artur-rios/fortuna-ui.git
cd fortuna-ui
flutter pub get
```

The API client and the FFI bindings are generated and committed, so a clean clone needs no
generation step. Regenerate them only after taking a new API contract:

```bash
dart run tool/generate_api_client.dart
dart run tool/generate_bindings.dart
```

### Running

Configuration is supplied at build time, so a run names the instance it talks to:

```bash
flutter run -d windows --dart-define=FORTUNA_API_BASE_URL=http://localhost:5000
```

Replace `-d windows` with `linux`, `chrome` or your Android device. A run with no
`FORTUNA_API_BASE_URL` starts at the setup screen instead of failing. Desktop offline mode is
selected with `--dart-define=FORTUNA_TRANSPORT=ffi`, and requires the Fortuna core library to be
present — see the
[Operations & Infrastructure Document](docs/requirements/Operations%20%26%20Infrastructure%20Document.md) §3.

## Testing

The suite described in the
[Testing Specification Document](docs/requirements/Testing%20Specification%20Document.md) runs with:

```bash
flutter analyze
flutter test
```

An analyzer failure is a failure. Integration tests live in `integration_test/` and are invoked
deliberately, so the fast suite stays fast:

```bash
flutter test integration_test -d windows
```

The suite covers **unit**, **widget** and **integration** tests. There is no numeric coverage floor:
the standard is that every use case's main flow and each of its `AF-xx` alternative flows has a test
that names it. Every use case ships with its tests before its pull request is opened.

## Roadmap

Seven milestones, in dependency order. Every milestone after `M-01` depends on it.

| Milestone | Delivers | Depends on | Issues | Status |
|---|---|---|---|---|
| [M-01 — Foundation](https://github.com/artur-rios/fortuna-ui/milestone/1) | The project scaffold, both transports, the generation pipelines and CI that every use case is built on | — | 1 | 0 / 1 closed |
| [M-02 — Access, shell and privacy](https://github.com/artur-rios/fortuna-ui/milestone/2) | Sign-in in every mode, the session, the app shell and its route guard, presentation preferences, the data rights screens and the administrative area | M-01 | 18 | 0 / 18 closed |
| [M-03 — Holdings](https://github.com/artur-rios/fortuna-ui/milestone/3) | Financial accounts, credit cards with billing cycles and statements, and investments | M-02 | 5 | 0 / 5 closed |
| [M-04 — Money movement and lifecycle](https://github.com/artur-rios/fortuna-ui/milestone/4) | Transactions, transfers, installments, recurrence, reconciliation, the spreadsheet view, and the deletion and audit surfaces | M-03 | 9 | 0 / 9 closed |
| [M-05 — Organization and planning](https://github.com/artur-rios/fortuna-ui/milestone/5) | Categories, tags, counterparties, budgets and goals | M-04 | 4 | 0 / 4 closed |
| [M-06 — Ingestion and attachments](https://github.com/artur-rios/fortuna-ui/milestone/6) | Connections, synchronization, file imports, job monitoring, imported records and attachments | M-04, M-05 | 6 | 0 / 6 closed |
| [M-07 — Insight and output](https://github.com/artur-rios/fortuna-ui/milestone/7) | Charts, drill-down, net position, projections and export | M-04, M-05 | 4 | 0 / 4 closed |

## Backlog

47 issues: one per use case, plus one foundation issue. The counts below are as of creation; each milestone's own page is the live view.

### M-01 — Foundation

| Issue | Work | Spec |
|---|---|---|
| [#1](https://github.com/artur-rios/fortuna-ui/issues/1) | Project scaffold and initial infrastructure | [Operations & Infrastructure](docs/requirements/Operations%20%26%20Infrastructure%20Document.md) |

### M-02 — Access, shell and privacy

| Issue | Work | Spec |
|---|---|---|
| [#2](https://github.com/artur-rios/fortuna-ui/issues/2) | UC-01 — Configure the Instance and Mode | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#3](https://github.com/artur-rios/fortuna-ui/issues/3) | UC-02 — Reach the Fortuna Core Over the Configured Transport | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#4](https://github.com/artur-rios/fortuna-ui/issues/4) | UC-03 — Sign In with Credentials | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#5](https://github.com/artur-rios/fortuna-ui/issues/5) | UC-04 — Complete a Two-Factor Challenge | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#6](https://github.com/artur-rios/fortuna-ui/issues/6) | UC-05 — Sign In with Google | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#7](https://github.com/artur-rios/fortuna-ui/issues/7) | UC-06 — Create a Desktop Local Account | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#8](https://github.com/artur-rios/fortuna-ui/issues/8) | UC-07 — Sign In to a Desktop Local Account | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#9](https://github.com/artur-rios/fortuna-ui/issues/9) | UC-08 — Recover a Desktop Local Account | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#10](https://github.com/artur-rios/fortuna-ui/issues/10) | UC-09 — Recover a Password and Verify an Address | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#11](https://github.com/artur-rios/fortuna-ui/issues/11) | UC-10 — Manage Two-Factor Authentication | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#12](https://github.com/artur-rios/fortuna-ui/issues/12) | UC-11 — Restore a Session at Start | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#13](https://github.com/artur-rios/fortuna-ui/issues/13) | UC-12 — End a Session | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#14](https://github.com/artur-rios/fortuna-ui/issues/14) | UC-13 — Choose Theme, Locale and Display Currency | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#43](https://github.com/artur-rios/fortuna-ui/issues/43) | UC-42 — Review, Give and Withdraw Consents | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#44](https://github.com/artur-rios/fortuna-ui/issues/44) | UC-43 — Export All Personal Data | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#45](https://github.com/artur-rios/fortuna-ui/issues/45) | UC-44 — Erase the Account | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#46](https://github.com/artur-rios/fortuna-ui/issues/46) | UC-45 — View Instance Health | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#47](https://github.com/artur-rios/fortuna-ui/issues/47) | UC-46 — Guard a Route by Session and Role | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

### M-03 — Holdings

| Issue | Work | Spec |
|---|---|---|
| [#15](https://github.com/artur-rios/fortuna-ui/issues/15) | UC-14 — Manage Financial Accounts | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#16](https://github.com/artur-rios/fortuna-ui/issues/16) | UC-15 — Manage Credit Cards | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#17](https://github.com/artur-rios/fortuna-ui/issues/17) | UC-16 — Review and Settle a Credit Card Statement | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#18](https://github.com/artur-rios/fortuna-ui/issues/18) | UC-17 — Manage Investments | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#19](https://github.com/artur-rios/fortuna-ui/issues/19) | UC-18 — Record an Investment Movement or Valuation | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

### M-04 — Money movement and lifecycle

| Issue | Work | Spec |
|---|---|---|
| [#20](https://github.com/artur-rios/fortuna-ui/issues/20) | UC-19 — Record a Transaction | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#21](https://github.com/artur-rios/fortuna-ui/issues/21) | UC-20 — Update or Delete a Transaction | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#22](https://github.com/artur-rios/fortuna-ui/issues/22) | UC-21 — Record a Transfer | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#23](https://github.com/artur-rios/fortuna-ui/issues/23) | UC-22 — Record an Installment Purchase | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#24](https://github.com/artur-rios/fortuna-ui/issues/24) | UC-23 — Manage Recurring Commitments | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#25](https://github.com/artur-rios/fortuna-ui/issues/25) | UC-24 — Reconcile a Transaction | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#26](https://github.com/artur-rios/fortuna-ui/issues/26) | UC-25 — Explore Records as a Spreadsheet | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#41](https://github.com/artur-rios/fortuna-ui/issues/41) | UC-40 — Restore or Permanently Remove a Deleted Record | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#42](https://github.com/artur-rios/fortuna-ui/issues/42) | UC-41 — Read the Audit Trail | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

### M-05 — Organization and planning

| Issue | Work | Spec |
|---|---|---|
| [#27](https://github.com/artur-rios/fortuna-ui/issues/27) | UC-26 — Manage the Category Tree | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#28](https://github.com/artur-rios/fortuna-ui/issues/28) | UC-27 — Manage Tags and Counterparties | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#29](https://github.com/artur-rios/fortuna-ui/issues/29) | UC-28 — Manage Budgets | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#30](https://github.com/artur-rios/fortuna-ui/issues/30) | UC-29 — Manage Goals | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

### M-06 — Ingestion and attachments

| Issue | Work | Spec |
|---|---|---|
| [#31](https://github.com/artur-rios/fortuna-ui/issues/31) | UC-30 — Connect an Institution | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#32](https://github.com/artur-rios/fortuna-ui/issues/32) | UC-31 — Synchronize, Reauthenticate or Revoke a Connection | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#33](https://github.com/artur-rios/fortuna-ui/issues/33) | UC-32 — Import a File | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#34](https://github.com/artur-rios/fortuna-ui/issues/34) | UC-33 — Monitor an Import Job | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#35](https://github.com/artur-rios/fortuna-ui/issues/35) | UC-34 — Review Imported Records | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#36](https://github.com/artur-rios/fortuna-ui/issues/36) | UC-35 — Manage a Transaction's Attachments | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

### M-07 — Insight and output

| Issue | Work | Spec |
|---|---|---|
| [#37](https://github.com/artur-rios/fortuna-ui/issues/37) | UC-36 — Read an Aggregation as a Chart | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#38](https://github.com/artur-rios/fortuna-ui/issues/38) | UC-37 — Drill Into a Chart Aggregation | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#39](https://github.com/artur-rios/fortuna-ui/issues/39) | UC-38 — View the Net Position, Projections and Obligations | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
| [#40](https://github.com/artur-rios/fortuna-ui/issues/40) | UC-39 — Export a Data Set | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |

## Contributing

One use case = one branch = one issue = one pull request. The full process — branch naming, the
issue status lifecycle, the four approval gates, the testing gate, and the Definition of Done — is
in the
[Development Workflow Document](docs/requirements/Development%20Workflow%20Document.md).
