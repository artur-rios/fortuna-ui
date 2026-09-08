# Technology Stack — Fortuna UI

Fortuna UI is built the same way as the [Heimdall UI](https://github.com/artur-rios/heimdall-ui):
the same framework, the same state and routing libraries, the same generated-client approach, the
same testing tools. That is a deliberate choice — the two applications are maintained by one
person, and a shared skeleton means a pattern learned in one is a pattern known in the other.

Exact versions are **not** pinned here. They are pinned once, in the formal Technology Stack
Document, which every other document links to instead of restating.

## Platform & Language

- **Flutter**, stable channel, with the **Dart** SDK that ships with it. Neither is pinned to a
  number: the version is the latest stable at implementation time, recorded once it is chosen.
- **Material 3** as the design system, with light and dark schemes derived from one seed color.
- `flutter_lints` for analysis, with strict casts and strict raw types enabled. Generated code is
  excluded from analysis.

## Application Type

A **multi-platform Flutter client application** — a pure consumer of the
[Fortuna API](https://github.com/artur-rios/fortuna-api). It has no server component of its own.

| Target | Notes |
| --- | --- |
| **Web** | Served as a static build from a container. |
| **Windows** | Desktop build; supports desktop offline mode. |
| **Linux** | Desktop build; supports desktop offline mode. |
| **Android** | Mobile build; connected mode only. |

**No iOS and no macOS.** Neither platform folder exists.

The application is organized by feature, mirroring Heimdall UI's `lib/` layout: a `core` for
configuration, networking, storage and cross-cutting result types; a `features` directory holding
one self-contained folder per domain area; and a `shared` for layout and reusable widgets.

## Data Storage

**No client-side database.** The connected experience holds no persistent copy of financial data —
every figure is read from the API when it is needed, because a cached balance is a second source of
truth for a number the API defines as derived, and a stale one on a money screen is worse than a
slow one.

What is stored on the client is deliberately small:

| What | Where |
| --- | --- |
| The session token and any refresh material | **flutter_secure_storage** — Keystore on Android, DPAPI on Windows, libsecret on Linux, encrypted local storage on the web. |
| Non-sensitive preferences — theme mode, locale, chosen display currency | **shared_preferences**. Never a credential, never a token. |
| Reference data during a session — currencies, the category tree, accounts, cards, tags, counterparties | In memory only, held by providers and invalidated explicitly whenever a mutation touches them. Gone when the application closes. |

Desktop offline mode does not change this. The SQLite database that mode uses belongs to the Fortuna
core the desktop package ships, not to this application — the client calls the core and gets the
same answers it would get from a server, and still owns none of the data.

## Data Access

The application reaches the Fortuna API over **two transports**, and everything above the data layer
is unaware of which one is in use. A feature calls a repository; the repository calls whichever
transport this installation was built for.

| Transport | Used by | How |
| --- | --- | --- |
| **HTTP** | Connected and self-hosted modes — the web, Android, and any desktop installation pointed at a remote instance | `dio` + the generated retrofit client. |
| **FFI** | Desktop offline mode, on Windows and Linux | `dart:ffi` against the Fortuna core shipped as a native library beside the application. No local web server, no port, no child process. |

The FFI side follows the pattern established in
[alexandria-ui](https://github.com/artur-rios/alexandria-ui):

- The core publishes a **C header**, which is vendored here verbatim and never hand-edited. CI diffs
  it against the source and fails on drift.
- **ffigen** generates the bindings from that header into a committed file that is excluded from
  analysis and never hand-edited.
- Every call crosses on a **worker isolate**, so the boundary never blocks a frame.
- `dart:ffi` appears **only** in the bindings layer. Nothing above the data layer imports it, and a
  lint rule enforces that.
- The core takes and returns the **same JSON bodies as the HTTP routes**, envelope included, so the
  generated HTTP models are reused rather than duplicated for the second transport.

The rest is shared by both:

- **dio** for HTTP. One configured instance is shared by the generated client, carrying the bearer
  token interceptor, the base address and the timeouts.
- **retrofit** as the generated client's runtime, with **json_annotation** for the models.
- The API client is **generated, not hand-written**: `swagger_parser` reads the Fortuna API's
  OpenAPI document and emits DTOs and typed clients into a local package, the way
  `heimdall_api_client` is produced in Heimdall UI. The generated package is committed and never
  hand-edited; ergonomic wrappers belong in the consuming feature's data layer.
- **flutter_riverpod** for dependency injection and state. Providers are the only global wiring;
  each feature owns its own.
- **go_router** for routing, which gives the web target real URLs and hosts the single redirect
  that guards every route by session and role.
- **decimal** for every monetary value, end to end. A money amount is parsed from the API's string
  representation into a `Decimal` and formatted for display from that — it is never a `double` at
  any point, in any layer, for any reason.

## Authentication

All authentication goes through the Fortuna API. This application never calls the identity provider
directly, and holds no second API client.

- **Email and password**, and **Google sign-in**, both through the API's `api/auth` surface. Google
  sign-in is also the sign-up path: a first Google sign-in creates the account.
- **Two-factor authentication** where the account has it enabled — the sign-in answers with a
  challenge, and the application collects the second factor and completes it. Two-factor setup,
  confirmation, disabling and recovery-code regeneration are all available in the application.
- **Desktop offline mode** authenticates against a local account held by the local API, recovered
  only by a recovery code.
- **The token lives in secure storage.** When it expires mid-session, the application asks for
  credentials again rather than attempting a silent refresh, and the interrupted action is not
  replayed automatically.
- **Two roles**: the account owner and the instance administrator. The route guard enforces which
  areas each may reach; the API enforces the truth.

## Testing

- **flutter_test** for unit and widget tests, **integration_test** for end-to-end flows.
- **mocktail** as the single mocking library — chosen over `mockito` because it needs no code
  generation. There is no second one.
- Dio's `HttpClientAdapter` is replaced in tests by a local adapter answering from memory, so no
  test reaches the network.
- Tests are named and written **Given / When / Then**.
- Money formatting and parsing, currency handling and the chart drill-down logic get unusually
  dense coverage: they are where a defect is silent and expensive.

## External Dependencies

| Dependency | Role | Notes |
| --- | --- | --- |
| **Fortuna API** | Everything | The only service this application calls for its own data. Its OpenAPI document is the input to client generation. |
| **Google Sign-In** | Obtaining the Google ID token | The single exception to "the API is the only service": the token is obtained here and handed to the API, which exchanges it. |

The application reaches **Pluggy**, the identity provider and every other integration **only
through the Fortuna API**, never directly.

Two further choices the brainstorm's features force, both free and open source:

- **fl_chart** for charts. It is the actively maintained, MIT-licensed option that covers line, bar,
  pie, scatter and radar, and — decisively — reports which element was touched, which is what makes
  the drill-down feature possible at all.
- **trina_grid** for the spreadsheet view. MIT, actively maintained, and carrying what the tabular
  view needs: server-side pagination, sorting, filtering, column freezing and typed columns.
  (`pluto_grid_plus`, the more commonly cited option, is discontinued and points here itself.)

## Localization

Four locales, from the first version: **`en-US`**, **`en-GB`**, **`en-150`** (English as used in
Europe) and **`pt-BR`**. Locale selection is a user preference, and it governs number, date and
currency formatting as much as it governs text — which matters more here than in most applications,
because the same amount reads differently under each of them.

## Deployment

Each target ships differently, and all four are produced from the same source by the same pipeline:

| Target | Shipped as |
| --- | --- |
| **Web** | A static build served from a **Docker** container on a VPS, behind **Traefik** as the reverse proxy and TLS terminator. |
| **Windows** | An **`.exe` installer**, plus a **portable `.zip`** requiring no installation. |
| **Linux** | An installer. |
| **Android** | An **APK**. |

The Windows and Linux packages — installer and portable alike — carry more than the client: they
install the Flutter application, the **Fortuna core as a native library** (`.dll` on Windows, `.so`
on Linux) that the application calls through FFI, and the **SQLite** database file the core uses.
That is what makes desktop offline mode work with no network, no server and nothing else installed.
The web and Android builds ship the client alone and require a reachable instance.
