# Business Rules — Fortuna UI

The rules this application must enforce, independently of how it is built. They are numbered
`BR-xx`; the formal System Requirements Document traces each one to the functional requirements
that realize it, so the numbers are stable — a rule that is withdrawn keeps its number rather than
letting the ones below it shift.

This is a **client**. The financial domain and its invariants belong to the
[Fortuna API](https://github.com/artur-rios/fortuna-api) and are stated in
[its own Business Rules](https://github.com/artur-rios/fortuna-api/blob/main/docs/initial/Business%20Rules.md).
Nothing here restates them. What follows is what this repository owns: what the application holds,
what it may display, what it may decide for itself, and where it must defer.

## Domain Entities

The application's own entities — the things it holds and reasons about. Every financial concept it
*shows* (a transaction, an account, a statement, a projection) is the API's, fetched and rendered,
and appears here only where the client adds something of its own.

| Entity | Represents |
| --- | --- |
| **Session** | Who is signed in, in which mode, with what role, and the token that proves it. The root of everything the application is allowed to do. |
| **Credential** | An email and password, or a Google ID token, or a local account secret, or a second factor. Exists only for the instant it takes to submit it. |
| **TwoFactorChallenge** | A sign-in that has been accepted but not completed, awaiting a second factor. Not a session, and grants nothing. |
| **InstanceConfiguration** | Which Fortuna instance this installation talks to, and in which of the three shapes — connected, self-hosted or desktop offline. |
| **Preferences** | The user's own choices about presentation: theme mode, locale and display currency. Not financial data. |
| **MoneyValue** | An exact decimal amount and its currency, as received from the API. The application's only representation of money. |
| **QueryState** | The filters, sort and page position of a table or chart view — what the user has narrowed to, held so the view survives navigation. |
| **DrillPath** | The trail of chart elements a user has descended through, and the aggregation level each represents. What makes a drill-down reversible. |
| **PendingUpload** | A file chosen for import, before the API has accepted it. |
| **JobHandle** | A reference to an asynchronous API operation — an import, a synchronization, an export — and its last known progress. |
| **Notice** | A message shown to the user: a validation failure, a refusal, an outcome. Derived from an API answer or a local validation, never invented. |

## Relationships

| Relationship | Cardinality |
| --- | --- |
| Application → Session | 1 : 0..1 (exactly one signed-in identity at a time, or none) |
| Session → Role | 1 : 1 (account owner, or instance administrator) |
| Credential → Session | N : 0..1 (a credential either yields a session, a challenge, or nothing) |
| TwoFactorChallenge → Session | 1 : 0..1 (completing a challenge yields at most one session) |
| Application → InstanceConfiguration | 1 : 1 |
| Application → Preferences | 1 : 1 |
| Preferences → Locale | 1 : 1 |
| MoneyValue → Currency | N : 1 |
| View → QueryState | 1 : 1 |
| Chart view → DrillPath | 1 : 1 |
| DrillPath → aggregation level | 1 : N (ordered, coarsest first) |
| PendingUpload → JobHandle | 1 : 0..1 (an accepted upload yields one job) |
| JobHandle → Notice | 1 : N |

## Rules

### Authority and trust

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-01** | The API is the sole authority on every fact the application displays. The client renders answers; it does not decide them. | Two systems computing the same balance means one of them is wrong and the user cannot tell which. |
| **BR-02** | The application never computes a balance, total, aggregation or projection. Where a figure is needed, it is requested. | Deriving a figure locally reimplements the domain in a second language, with no tests over the money rules that make it correct. |
| **BR-03** | Client-side validation exists to give immediate feedback, never to grant permission. Every submission is sent and every refusal is honored, including one the client believed would succeed. | A client check is a convenience for the user; treating it as authority is how a client ships a rule the API does not have. |
| **BR-04** | An action is not reported as successful until the API has confirmed it. Nothing is displayed as saved on optimism. | In a financial record, a write that appears to have happened and did not is worse than a visible failure. |
| **BR-05** | Where the API refuses, the application shows the API's reason. It does not translate a refusal into a different one, soften it, or substitute a generic message that hides what happened. | A user who cannot see why something was refused cannot fix it. |

### Money and presentation

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-06** | A monetary amount is held as an exact decimal, parsed from the API's representation and never converted to a binary floating-point type — not in a model, a widget, an intermediate expression, a chart coordinate, a test fixture, or a log line. | This is the API's own first rule, and a client that breaks it corrupts the display of data the API stored perfectly. |
| **BR-07** | Every amount is displayed with its own currency, and amounts in different currencies are never visually summed or presented as comparable without the API having converted them. | An implied conversion is an invented number, whether it is invented on the server or in a chart axis. |
| **BR-08** | Rounding happens at display only, to the currency's minor-unit precision, and never to a value carried onward. | A rounded value used in a later step is how a total stops matching the sum of its parts. |
| **BR-09** | Amounts, dates and numbers are formatted according to the user's chosen locale, and the chosen locale never alters the value — only its rendering. | The same amount reads differently in `pt-BR` and `en-US`; the figure underneath must be identical. |
| **BR-10** | A chart coordinate derived from a monetary amount is a presentation artifact and is never read back as the value. The value comes from the data behind the point. | A pixel position is lossy by definition, and a drill-down that reads one has lost the number. |

### Projections, deletions and what a figure means

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-11** | A projected or scheduled figure is always visually distinguishable from a recorded one, in every view that mixes them, including charts, tables and exports the user sees on screen. | A user must never mistake a forecast for a fact. |
| **BR-12** | A soft-deleted record is shown only where the user has asked to see deleted records, and always marked as deleted. | A deleted record appearing as live contradicts the totals it is excluded from. |
| **BR-13** | Any aggregate the application draws must be drillable to the records that produced it, and a drill-down is reversible to the level it came from. | A chart the user cannot get behind is a number they have to take on faith — and one they cannot get back out of is a trap. |
| **BR-14** | Every drill-down level is requested from the API. The application never subdivides an aggregate it already holds. | Subdividing locally re-derives the domain's aggregation rules by guesswork. |

### Session and credentials

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-15** | A credential exists only for the duration of the submission that carries it. It is never written to disk, held in a provider after use, logged, included in a crash report, or retained in a form the user has left. | A credential the application keeps is a credential the application can leak. |
| **BR-16** | The session token is stored only in the platform's secure storage, never in preferences, never in application state that outlives the session, never in a URL. | Every other location is readable by something that should not read it. |
| **BR-17** | When the token expires or is rejected mid-session, the application ends the session and asks for credentials again. It does not attempt a silent refresh, and it does not replay the interrupted action automatically. | Silently replaying a financial write the user cannot see is how an action happens twice. |
| **BR-18** | Signing out clears the token, every cached reference value and every view's state, so that nothing about the previous user survives into the next session. | A shared desktop is the normal case, not the exception. |
| **BR-19** | A two-factor challenge grants nothing. Until it is completed, the application is in the same state as signed out. | A half-authenticated session is an authenticated session with extra steps. |
| **BR-20** | The application authenticates only through the Fortuna API. The single exception is obtaining a Google ID token, which is then handed to the API to exchange. | One integration point means one place where a token can be got wrong. |

### Roles and reachability

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-21** | The interface presents only what the signed-in role may do. An account owner sees no administrative surface; an instance administrator sees no financial data anywhere, including in a chart, a total, an export or an error message. | The API refuses either way, but an interface that offers what will be refused is a broken interface. |
| **BR-22** | Route guarding is enforced centrally, and a route reached by any means — a typed web URL, a deep link, a restored session — passes the same guard. | A guard applied per screen is a guard somebody forgets. |
| **BR-23** | Hiding a control is never the only protection. Nothing the interface conceals is reachable by manipulating client state. | Concealment is a courtesy to the user, not a security boundary. |

### Modes and platforms

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-24** | The three modes — connected, self-hosted and desktop offline — share one interface. They differ in which instance is addressed and which sign-in paths are offered, never in what the application looks like or how a feature behaves. | "One interface, four platforms" is the point of the project; a mode-specific interface is a second application. |
| **BR-25** | Desktop offline mode is available on Windows and Linux only, and is offered only where the installation actually provides a local instance. It is never offered on the web or Android. | An offline option that cannot work is worse than no option. |
| **BR-26** | Outside desktop offline mode, the application does not pretend to work without the API. A lost connection is reported as a lost connection. | A cache impersonating a live system shows stale money as current. |
| **BR-27** | Platform differences are confined to what genuinely differs — file selection, file saving, window chrome, secure-storage backing and the availability of offline mode. Nothing else branches on platform. | Every avoidable branch is a place the four targets drift apart. |

### Files and long-running work

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-28** | An import file is uploaded whole and unmodified. The application never parses, transforms, filters or repairs it. | The API's imported record is meant to be exactly what the source said; a client that edits it destroys the evidence an import is reconciled against. |
| **BR-29** | An export is produced by the API and only saved by the application. The client never renders a CSV, a spreadsheet or a PDF of its own. | Two renderers for one export means two different files claiming to be the same data. |
| **BR-30** | Work the API defines as asynchronous — imports, synchronizations, exports — never blocks the interface. It reports progress, survives navigation away, and its outcome remains findable afterwards. | A user who navigates away from a running import must not lose it. |
| **BR-31** | A per-row import outcome is shown as the API reported it — imported, skipped as a duplicate, or rejected with its reason — and the application never summarizes those away into a single success or failure. | One malformed row in a 400-row statement is information the user needs, not noise to hide. |

### Data handling

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-32** | The application holds no persistent copy of financial data. What it caches in memory is reference data only — currencies, categories, accounts, cards, tags, counterparties — for the duration of a session. | A cached balance is a second source of truth for a number the API defines as derived. |
| **BR-33** | Cached reference data is invalidated explicitly whenever a mutation could have changed it. Nothing is served from cache after the user has changed it. | Stale reference data quietly attaches new records to the wrong category. |
| **BR-34** | Financial data never reaches a log, a crash report, an analytics payload or any destination outside the API. | Data the user self-hosts precisely so nobody else sees it must not leave through a diagnostic channel. |

### The core boundary

Desktop offline mode reaches the Fortuna core in process, through FFI, rather than over HTTP. That
is a transport, not a second system, and these rules keep it one.

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-35** | The transport is invisible above the data layer. A feature, a provider, a screen and a test all behave identically whether the answer came over HTTP or across the FFI boundary. | A transport that leaks upward means every feature is written twice and tested once. |
| **BR-36** | `dart:ffi` appears only in the bindings layer, and the generated bindings are never hand-edited. A wrong binding means a wrong header; it is fixed at the source and regenerated. | Hand-editing a generated binding produces a boundary that compiles and is wrong, which is the worst failure mode this layer has. |
| **BR-37** | Every call across the boundary runs off the UI isolate, and every string the core returns is released, including on the failure paths. | A native call on the UI isolate drops frames, and a leak at a boundary crossed thousands of times a session is unbounded. |

### Privacy and compliance

The application is built to satisfy the **GDPR** and the **LGPD**. Most of the obligation sits with
the API, which holds the data; what follows is what a client owes.

| # | Rule | Rationale |
| --- | --- | --- |
| **BR-38** | Who the data controller is depends on the deployment shape, and the interface reflects it. In a self-hosted or desktop offline installation the user is their own controller, and the application says so rather than implying a service stands behind it. On a shared instance the operator is the controller, and the application surfaces the privacy notice and the route for exercising rights. | The same screens under two legal shapes mislead in one of them. |
| **BR-39** | No data leaves this application except to the Fortuna API. There is no analytics, no crash reporting, no telemetry and no third-party SDK that observes use. | The simplest way to satisfy a data protection regime is to have no second destination to account for. |
| **BR-40** | Before any action that hands data to an external processor, the application presents the disclosure and records the user's decision. Consent is never inferred from use of a feature, and withdrawing it is offered wherever granting it was. | Both regimes require a lawful basis established beforehand, and withdrawal as easy as consent. |
| **BR-41** | The application offers the user a way to take all of their data, and a way to erase their account — each reachable from the interface without contacting anyone. | A right that requires an email to exercise is a right most people never exercise. |
| **BR-42** | Erasure is presented as irreversible and confirmed explicitly, and is never dressed as the ordinary two-stage deletion of a record. The application states what survives — the audit trail, which no longer identifies the user. | A user who confirms an erasure believing it is recoverable has not consented to what happened. |

## Validation Constraints

Client-side validation mirrors the API's, to fail fast in the form rather than in a round trip. The
API remains the authority (`BR-03`), and where the two ever disagree, the API is right.

| Screen area | Field | Constraint |
| --- | --- | --- |
| Sign-in | Email | Required, well-formed. |
| Sign-in | Password | Required, non-empty. Never retained after submission. |
| Two-factor | Code | Required; an authenticator or email code, or a recovery code. |
| Local account | User name | Required. |
| Local account | Recovery code | Required; single-use, and the user is told plainly that it is spent. |
| Instance configuration | Address | Required, a well-formed URL, before any request is attempted. |
| Account / card / investment | Name | Required. |
| Account / card / investment | Currency | Required, chosen from the API's supported list, and not editable after creation. |
| Credit card | Credit limit | Required, greater than zero. |
| Credit card | Closing day, due day | Required, 1–31. |
| Transaction | Amount | Required, greater than zero, entered and held as an exact decimal — the input never parses through a floating-point type. |
| Transaction | Date | Required; a date more than one day ahead is refused in the form, with the reason given. |
| Transaction | Direction | Required: expense or earning. |
| Transaction | Account, category | Required, chosen from the user's own. |
| Transfer | Origin, destination | Both required, and different from each other. |
| Installment plan | Installment count | Required, an integer of at least two. |
| Recurring transaction | Schedule | Required; frequency and start date, with an end date not before the start. |
| Category | Name | Required. |
| Category | Parent | Optional; the interface never offers a parent that would create a cycle. |
| Budget / goal | Amount | Required, greater than zero. |
| Goal | Target date | Required, in the future. |
| Import | File | Required; the type is checked against what the chosen source accepts before upload. |
| Filters | Date range | Start not after end. |

## Permissions

| Capability | Account owner | Instance administrator |
| --- | --- | --- |
| Sign in, sign out, manage their own two-factor authentication | Yes | Yes |
| View and manage their own accounts, cards, investments and transactions | Yes | No |
| View charts, tables, projections and net position over their own data | Yes | No |
| Import, synchronize and export their own data | Yes | No |
| Manage their own categories, tags, counterparties, budgets and goals | Yes | No |
| Manage their own connections to external sources | Yes | No |
| Restore or permanently remove a record they have already deleted | Yes | No |
| Read their own audit trail | Yes | No |
| Reach the administrative area at all | No | Yes |
| View instance health and operational status | No | Yes |
| See any user's financial figures, anywhere in the interface | No | **No** |

The role comes from the session the API issued. A desktop local account is always an account owner,
and no administrative surface exists in an offline installation.

## Lifecycle

**Application start.** Resolve the instance configuration, then attempt to restore a session from
secure storage. A restored session is verified against the API before any screen that depends on it
is shown; a token the API rejects is discarded and the user is asked to sign in.

**Session states.** `SignedOut` → `Authenticating` → `ChallengePending` (two-factor only) →
`SignedIn` → `SignedOut`. Expiry moves `SignedIn` directly to `SignedOut` (`BR-17`). No state but
`SignedIn` reaches a screen holding financial data.

**View states.** Every data-backed view is one of `Loading`, `Loaded`, `Empty`, or `Failed`. All
four are designed, and `Failed` always offers a retry. A view never shows stale content while
reloading in a way that suggests the content is current.

**Job states.** A `JobHandle` follows the API's own job lifecycle — pending, running, completed or
failed — and its outcome stays reachable after completion until the user dismisses it.

**Deletion.** The interface presents the API's two stages as two distinct, separately confirmed
actions: deleting a record, and then permanently removing one already deleted. The second always
states that it cannot be undone.

**Sign-out.** Clears the token, all cached reference data and all view state (`BR-18`).

## Prohibitions

- **Never represent money in binary floating point** — not in a model, a widget, a chart, a test, or
  a log line.
- **Never compute a financial figure locally.** Not a balance, not a total, not a conversion, not a
  projection, not the next level of an aggregation.
- **Never persist a credential**, and never retain one past the request that carries it.
- **Never store a token anywhere but the platform's secure storage.**
- **Never write financial data outside the API** — no log, no crash report, no analytics, no local
  file the application writes itself.
- **Never call an external service directly.** Every integration goes through the Fortuna API; only
  the Google ID token is obtained here.
- **Never hand-edit the generated API client, or the generated FFI bindings.** A wrong client means
  a wrong API contract, and a wrong binding means a wrong header; both are fixed at the source and
  regenerated.
- **Never call `dart:ffi` outside the bindings layer**, and never block the UI isolate on a call
  across the boundary.
- **Never present a projection as recorded history.**
- **Never treat a hidden control as a permission check.**
- **Never report a write as successful before the API has confirmed it**, and never retry one
  automatically after an authentication failure.
