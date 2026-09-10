# Technology Stack Document — Fortuna UI

## 1. Purpose

This document is the **single source of truth for the technologies used to build Fortuna UI** — the
framework, language, state management, routing, the two transports it reaches the API through,
storage, code generation, and testing tools, together with the version each is pinned to and the
role it plays.

Every other document in this folder **references this document** for technical choices instead of
restating them, so that:

- The domain documents ([Vision](Vision%20Document.md),
  [System Requirements](System%20Requirements%20Document.md),
  [Use Case Specification](Use%20Case%20Specification%20Document.md)) stay focused on *what* the
  application does.
- The [Operations & Infrastructure Document](Operations%20%26%20Infrastructure%20Document.md) stays
  focused on the platform's structure and operations.
- The [Testing Specification Document](Testing%20Specification%20Document.md) stays focused on *how*
  to test.
- Technology versions and roles are maintained in exactly **one** place.

> **Rule:** when a technology choice changes, it changes here first. Other documents link to this
> one rather than duplicating the detail.

### 1.1 The version policy

No version in this document is a number, and that is deliberate rather than unfinished. Every
technology below is taken at **the latest stable release at implementation time**, resolved when the
work is actually done rather than guessed in advance and stale by the time anyone builds.

What makes that safe rather than vague:

- `pubspec.yaml` declares the constraint that was current when the dependency was added.
- **`pubspec.lock` is the authoritative record** of what a build actually resolved, and it is
  committed.
- An upgrade is a deliberate change to those files, reviewed like any other.

Where a version genuinely matters — a package that must not be upgraded, or one whose behavior a
requirement depends on — it is recorded here as a constraint with its reason. There are none today.

---

## 2. Platform & Language

| Concern | Choice | Notes |
| --- | --- | --- |
| Framework | **Flutter**, stable channel | Latest stable at implementation time. One code base for every target. |
| Language | **Dart** | Whichever SDK ships with the Flutter version above. Pattern matching, sealed classes and exhaustive `switch` expressions are used freely; the session and result models depend on them. |
| Design system | **Material 3** | `useMaterial3: true`, with light and dark schemes derived from one seed color. |
| Targets | **Web, Windows, Linux, Android** | No iOS and no macOS platform folder exists. |
| Analysis | `flutter_lints`, with `strict-casts` and `strict-raw-types` enabled | Generated code — the API client and the FFI bindings — is excluded from analysis. Nothing else is. |

---

## 3. Libraries

All at the latest stable release at implementation time, per §1.1.

### 3.1 Application

| Package | Version | Used by | Role |
| --- | --- | --- | --- |
| **flutter_riverpod** | latest stable at implementation time | Every feature | Dependency injection and state. Providers are the only global wiring; each feature owns its own. `Notifier` and `AsyncNotifier` back the session, the theme and the locale. |
| **go_router** | latest stable at implementation time | `app` | Declarative routing. Gives the web target real URLs, and hosts the single redirect that guards every route by session and role. |
| **dio** | latest stable at implementation time | The HTTP transport | One configured instance shared by the generated client, carrying the bearer-token interceptor, the base address and the timeouts. |
| **retrofit** | latest stable at implementation time | The generated client | The generated clients' runtime: turns the annotated interfaces into `dio` calls. |
| **json_annotation** | latest stable at implementation time | The generated models | The models' runtime, paired with `json_serializable` at build time. |
| **decimal** | latest stable at implementation time | Everything that touches money | The only representation of a monetary amount. See §6.1 — this is the most consequential dependency in the list. |
| **intl** | latest stable at implementation time | Formatting and localization | Locale-aware number, date and currency formatting for the four supported locales. |
| **flutter_secure_storage** | latest stable at implementation time | `core/storage` | Token storage: Keystore on Android, DPAPI on Windows, libsecret on Linux, WebCrypto-encrypted local storage on the web. |
| **shared_preferences** | latest stable at implementation time | `core/storage` | Non-sensitive preferences — theme mode, locale, display currency. Never a token, never a credential. |
| **google_sign_in** | latest stable at implementation time | `features/auth` | Obtains the Google ID token the API exchanges for a session. |
| **qr_flutter** | latest stable at implementation time | `features/auth` | Renders the authenticator setup as a scannable code (`FR-SE-13`). The same secret is always offered as text beside it, so the image is never the only way through. |
| **fl_chart** | latest stable at implementation time | `features/insight` | Charts. Chosen over the alternatives because it is MIT-licensed, actively maintained, and reports which element was touched — which is what makes drill-down possible at all. |
| **trina_grid** | latest stable at implementation time | `features/insight` | The spreadsheet view: server-side pagination, sorting, filtering, column freezing and typed columns. Chosen over `pluto_grid_plus`, which is discontinued and directs users here. |
| **file_picker** | latest stable at implementation time | `features/ingestion` | Selecting a workbook or statement file for upload, across all four targets. |
| **file_saver** | latest stable at implementation time | `features/insight` | Saving an export the API produced, across all four targets. |

### 3.2 Code generation

| Package | Version | Role |
| --- | --- | --- |
| **swagger_parser** | latest stable at implementation time | Generates the DTOs and retrofit clients in `packages/fortuna_api_client/lib` from the API's OpenAPI document. Pure Dart, so no Java toolchain is required. Configured by `swagger_parser.yaml`. |
| **ffigen** | latest stable at implementation time | Generates the Dart bindings over the Fortuna core's C ABI from the vendored header. Configured by `ffigen.yaml`. |
| **build_runner** | latest stable at implementation time | Runs the generators. |
| **json_serializable** | latest stable at implementation time | Emits the `fromJson`/`toJson` bodies for the generated models. |
| **retrofit_generator** | latest stable at implementation time | Emits the client implementations. |

Both generated outputs are **committed and never hand-edited**, and CI regenerates each and fails on
any difference. The generation pipelines are described in
[Operations & Infrastructure §4](Operations%20%26%20Infrastructure%20Document.md).

---

## 4. Data Storage

The application holds **no persistent copy of financial data**. What it stores is small and
deliberate.

| Concern | Choice |
| --- | --- |
| Session token | **flutter_secure_storage** — the platform's own secure backing on each target. The only place a token is ever written. |
| Preferences | **shared_preferences** — theme mode, locale, display currency. Never a token, never a credential, never a figure. |
| Reference data | **In memory only**, held by providers for the duration of a session and invalidated explicitly when a mutation could have changed it. Gone when the application closes. |
| Financial data | **Nowhere.** Read from the API when needed and never persisted. |

Desktop offline mode does not change this. The **SQLite** database that mode uses belongs to the
Fortuna core the desktop package ships, not to this application — the client calls the core and gets
the same answers it would get from a server, and still owns none of the data.

---

## 5. Data Access

The application reaches the Fortuna API over **two transports**. Everything above the data layer is
unaware of which is in use: a feature calls a repository, and the repository calls whichever
transport the installation was built for.

| Transport | Used by | Mechanism |
| --- | --- | --- |
| **HTTP** | Connected and self-hosted modes — web, Android, and any desktop installation pointed at a remote instance | `dio` + the generated retrofit client. |
| **FFI** | Desktop offline mode, Windows and Linux only | `dart:ffi` against the Fortuna core shipped as a native library beside the application. No local server, no port, no child process. |

### 5.1 The FFI boundary

Follows the pattern established in [alexandria-ui](https://github.com/artur-rios/alexandria-ui):

| Concern | Choice |
| --- | --- |
| Contract | The core's **C header**, vendored verbatim at `native/include/` and never hand-edited. CI diffs it against the source and fails on drift. |
| Bindings | Generated by **ffigen** into a committed file, excluded from analysis, never hand-edited. |
| Threading | Every call crosses on a **worker isolate**. The boundary never blocks a frame. |
| Isolation | `dart:ffi` appears only in the bindings layer. Nothing above the data layer imports it, and a lint rule enforces it. |
| Payloads | The same JSON bodies the HTTP routes take and return, envelope included — so the generated HTTP models are reused rather than duplicated. |
| Memory | Every string the core returns is released, including on the failure paths. |

### 5.2 The access pattern

Each feature owns a repository interface and one implementation per transport. Providers depend on
the interface, never on `dio` and never on the bindings. That is what makes a feature testable
against a fake repository without a network or a native library, which the
[Testing Specification Document](Testing%20Specification%20Document.md) depends on throughout.

---

## 6. Cross-Cutting Technologies

| Concern | Technology | Version | How it is used |
| --- | --- | --- | --- |
| Money | **decimal** | latest stable at implementation time | Every monetary amount, end to end. See §6.1. |
| Formatting and localization | **intl** | latest stable at implementation time | Locale-aware number, date and currency formatting for `en-US`, `en-GB`, `en-150` and `pt-BR`. |
| State and injection | **flutter_riverpod** | latest stable at implementation time | Providers are the only global wiring. |
| Routing and route guarding | **go_router** | latest stable at implementation time | One central redirect guards every route by session and role. |
| Secure storage | **flutter_secure_storage** | latest stable at implementation time | The token, and nothing else. |
| Preferences | **shared_preferences** | latest stable at implementation time | Presentation choices only. |
| Error / result model | Sealed Dart classes in `core/result` | — | Every repository returns a result rather than throwing. A failure is a value the interface renders, per `BR-05`. |
| Configuration | `--dart-define` at build time | — | See [Operations & Infrastructure §3](Operations%20%26%20Infrastructure%20Document.md). |
| Logging | Dart's `developer.log`, debug builds only | — | Never carries financial data, a credential or a token (`BR-34`). No log ships in a release build. |
| Crash reporting / analytics | **None** | — | Deliberately absent (`BR-39`). Server-side observability is Prometheus and Loki, which are the API's concern. |

### 6.1 Money

The most consequential technology decision in this document, and the one most easily broken by an
ordinary-looking change.

A monetary amount is **parsed from the API's string representation into a `Decimal`, held as a
`Decimal`, and formatted for display from a `Decimal`**. It is never a `double` — not in a model, a
widget, an intermediate expression, a chart coordinate, a test fixture, or a log line.

The pressure comes from `fl_chart`, which necessarily plots in `double`. That conversion happens at
the drawing layer only, on a value that is never read back: the number behind a chart element comes
from the data the element was built from, not from its coordinate (`BR-10`).

---

## 7. Testing Technologies

These are the technologies mandated for tests. **How** they are applied — naming, structure,
coverage, the per-use-case workflow — is defined in the
[Testing Specification Document](Testing%20Specification%20Document.md); this section is the
canonical list of tools and versions.

| Concern | Technology | Version | How it is used |
| --- | --- | --- | --- |
| Test framework | **flutter_test** | Ships with the Flutter SDK | Unit and widget tests. |
| End-to-end | **integration_test** | Ships with the Flutter SDK | Drives complete flows against a stubbed API. |
| Coverage | `flutter test --coverage` | Ships with the Flutter SDK | Emits `lcov.info`. |
| Mocking / test doubles | **mocktail** | latest stable at implementation time | The single mocking library, for repositories and other collaborators. Chosen over `mockito` because it needs no code generation. Do not introduce a second one. |
| HTTP stubbing | `dio`'s `HttpClientAdapter` | — | Replaced in tests by a local adapter answering from memory, so no test reaches the network. |
| FFI stubbing | A fake repository at the same seam | — | The bindings layer is not exercised in unit tests; the repository interface is. Boundary behavior is the core's own test surface. |

---

## 8. Version Summary

Every technology named above appears here exactly once. This is the table to check when upgrading.

| Category | Package / Tool | Version |
| --- | --- | --- |
| Platform | Flutter (stable channel) | latest stable at implementation time |
| Language | Dart | ships with Flutter |
| Design system | Material 3 | ships with Flutter |
| Analysis | flutter_lints | latest stable at implementation time |
| State | flutter_riverpod | latest stable at implementation time |
| Routing | go_router | latest stable at implementation time |
| HTTP | dio | latest stable at implementation time |
| HTTP client runtime | retrofit | latest stable at implementation time |
| Model runtime | json_annotation | latest stable at implementation time |
| Money | decimal | latest stable at implementation time |
| Formatting | intl | latest stable at implementation time |
| Secure storage | flutter_secure_storage | latest stable at implementation time |
| Preferences | shared_preferences | latest stable at implementation time |
| Identity | google_sign_in | latest stable at implementation time |
| Identity | qr_flutter | latest stable at implementation time |
| Charts | fl_chart | latest stable at implementation time |
| Data grid | trina_grid | latest stable at implementation time |
| File selection | file_picker | latest stable at implementation time |
| File saving | file_saver | latest stable at implementation time |
| Generation | swagger_parser | latest stable at implementation time |
| Generation | ffigen | latest stable at implementation time |
| Generation | build_runner | latest stable at implementation time |
| Generation | json_serializable | latest stable at implementation time |
| Generation | retrofit_generator | latest stable at implementation time |
| Testing | flutter_test | ships with the Flutter SDK |
| Testing | integration_test | ships with the Flutter SDK |
| Testing | mocktail | latest stable at implementation time |
