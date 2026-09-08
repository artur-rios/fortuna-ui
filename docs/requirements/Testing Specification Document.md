# Testing Specification Document — Fortuna UI

## 1. Purpose

This document defines **how a use case is tested once it has been implemented**. It is a standard to
be followed by any human or agent that builds tests for this project, so that every use case in the
[Use Case Specification Document](Use%20Case%20Specification%20Document.md) receives the same shape
of testing, with the same tools, naming and structure.

The rule is simple:

> **After a use case is developed, tests are built for it in the same change — before it is
> considered done.** A use case without its tests is incomplete.

The tools and versions used are defined in the
[Technology Stack Document](Technology%20Stack%20Document.md); when the tests run in the delivery
flow is defined in the [Development Workflow Document](Development%20Workflow%20Document.md).

## 2. Testing philosophy

1. **Behavior-driven.** A test describes what the user or the caller observes, not how the code
   arranges itself. Renaming a private method must not break a test; changing what a screen does
   must.
2. **Test at the right layer.** Validation, formatting, parsing, state transitions and repository
   contracts are unit-tested. Anything a user sees — a screen's states, its errors, its empty
   states — is widget-tested. A complete journey across several screens is integration-tested. No
   logic is tested twice at two layers on purpose.
3. **Isolation in unit tests.** A unit test reaches no network, no native library, no platform
   channel and no clock it does not control. Collaborators are replaced at the repository seam,
   which is exactly why that seam exists.
4. **Realism where it counts.** Widget and integration tests run against a stubbed API that answers
   with **real recorded payloads** — the envelope, the field names and the string-encoded decimals
   the API actually sends — rather than hand-simplified fixtures. A fixture that is tidier than
   reality tests a system that does not exist.
5. **Money is tested harder than anything else.** Parsing, holding, formatting and displaying a
   monetary amount is where a defect is silent, plausible-looking and expensive. It gets denser
   coverage than any other area, including cases chosen specifically to expose a floating-point
   round trip.
6. **Same pattern every time.** The workflow in §8 is applied identically to every use case.

## 3. What to test for each use case

| Artifact produced | Test kind | Test location |
| --- | --- | --- |
| A repository interface and its implementations | Unit | `test/features/<feature>/data/` |
| A provider, notifier or controller | Unit | `test/features/<feature>/state/` |
| A form validator | Unit | `test/features/<feature>/validation/` |
| A formatter, parser or money conversion | Unit | `test/core/format/` |
| A screen or a reusable widget | Widget | `test/features/<feature>/ui/` |
| A route guard rule | Unit + widget | `test/app/` |
| A complete user journey across screens | Integration | `integration_test/` |

**What deliberately gets no tests**, so the suite does not fill with ceremony:

- **Generated code** — the API client and the FFI bindings. They are regenerated and drift-checked
  in CI, which is a stronger guarantee than a test asserting a generator's output.
- **Plain data holders with no behavior.** A model that only carries fields is exercised by the
  tests of whatever uses it.
- **Pure layout with no logic** — spacing, padding, decorative widgets. A widget test belongs where
  a screen makes a decision, not where it merely arranges boxes.
- **The Flutter framework and the packages this project depends on.** Their correctness is not this
  suite's job.

## 4. Test project layout

The test tree mirrors the source tree exactly. A reader who knows where a file lives knows where its
test lives, without searching.

```
lib/
├── app/                         → test/app/
├── core/
│   ├── config/                  → test/core/config/
│   ├── format/                  → test/core/format/
│   ├── network/                 → test/core/network/
│   ├── bindings/                → (generated; not unit-tested)
│   ├── result/                  → test/core/result/
│   ├── session/                 → test/core/session/
│   └── storage/                 → test/core/storage/
├── features/
│   └── <feature>/
│       ├── data/                → test/features/<feature>/data/
│       ├── state/               → test/features/<feature>/state/
│       ├── validation/          → test/features/<feature>/validation/
│       └── ui/                  → test/features/<feature>/ui/
└── shared/                      → test/shared/

integration_test/                → complete journeys, one file per journey
test/support/                    → shared fakes, stub payloads, pump helpers
```

**Naming rule:** a production file `lib/<path>/thing.dart` is tested by
`test/<path>/thing_test.dart`. One production unit, one test file.

## 5. Naming & structure

Every test is named with the **Given / When / Then** pattern, as a readable sentence:

```dart
test('Given an amount with more decimals than the currency allows '
     'When it is formatted '
     'Then it is rounded only for display and the held value is unchanged', () { … });
```

Every test body follows the same three-part shape, and the parts are separated by blank lines rather
than by comments:

```dart
test('Given a rejected token '
     'When a request is made '
     'Then the session ends and the action is not replayed', () async {
  final repository = FakeSessionRepository()..willReject();
  final notifier = SessionNotifier(repository);

  await notifier.refresh();

  expect(notifier.state, isA<SignedOut>());
  expect(repository.replayCount, 0);
});
```

Group related tests with `group()` named after the unit under test, so a failure report reads as
`SessionNotifier › Given a rejected token …`.

## 6. Unit testing standard

### 6.1 Scope of a unit test

One unit test exercises **one production unit** — a validator, a formatter, a notifier, a repository
implementation — with every collaborator replaced. It must not:

- reach the network, the file system, secure storage or a native library;
- depend on the real clock, the real locale, or the real platform;
- assert on more than the unit's own observable behavior.

A test that needs three collaborators wired together is a signal that the logic belongs somewhere
else, or that the test belongs at the widget layer.

### 6.2 Test doubles

| Collaborator | Double |
| --- | --- |
| A repository | A hand-written fake in `test/support/`, which is usually clearer than a mock for something with state |
| A single-method collaborator | `mocktail` |
| `dio` | The `HttpClientAdapter` replaced by a local adapter answering from memory |
| The FFI boundary | Not doubled — it is not reached. Tests substitute at the repository interface above it |
| Secure storage and preferences | In-memory fakes |
| The clock | An injected clock, never `DateTime.now()` in production code |

**`mocktail` is the only mocking library.** Do not introduce a second one.

### 6.3 Coverage per unit

For each production unit, walk this checklist:

- [ ] The happy path.
- [ ] Each validation failure the unit itself enforces.
- [ ] Each failure result the unit can receive from its collaborators, including the API's own
      refusals.
- [ ] Each boundary: empty, one, many; the smallest and largest values; the first and last page.
- [ ] Each state transition the unit can make, including the ones it must refuse.
- [ ] For anything touching money: a value with more decimal places than the currency permits; a
      value that a `double` would not represent exactly; a large value; a negative-adjacent value
      such as zero; and the same value under all four locales.

### 6.4 The money rule, as a test

Beyond per-unit coverage, the suite carries a standing test that **no monetary value is represented
as a `double`**: an analysis-level check that the money types expose no floating-point conversion,
and unit tests that round-trip values a `double` would corrupt. This test exists to fail when
somebody adds a convenient `toDouble()` — which is the exact change that would otherwise pass
review.

## 7. Widget and integration testing standard

### 7.1 Widget tests

A widget test pumps **one screen** with its providers overridden to fakes, and asserts what the user
sees. For every screen a use case adds or changes, it covers:

- the **loading** state;
- the **loaded** state, with the content the fake supplied;
- the **empty** state, and that it reads as empty rather than broken;
- the **failed** state, and that a retry is offered and works;
- every **alternative flow** of the use case that has a visible outcome — an inline field error, a
  refusal message, a confirmation, a disabled action with its reason;
- that a monetary amount renders with its currency, correctly, under each locale the use case's
  screen can display.

### 7.2 Integration tests

An integration test drives a **complete journey** across screens against a stubbed API — sign in,
record a transaction, see it in the table; or open a chart, drill to the transactions, step back
out. It uses the real routing, the real providers and the real widgets, with only the transport
stubbed.

Integration tests are deliberately few. They cover the journeys that would be embarrassing to break,
not every path: at minimum sign-in through to the overview, recording and finding a transaction, a
full drill-down and back, an import from file selection to per-row outcomes, and an export.

### 7.3 External dependencies

| Dependency | In tests |
| --- | --- |
| The Fortuna API over HTTP | A local `dio` adapter answering from recorded payloads. **No test reaches the network.** |
| The Fortuna core over FFI | Not loaded. Tests substitute at the repository interface; the boundary's own correctness is the core's test surface. |
| Google Sign-In | A fake returning a canned ID token, or a canned cancellation. |
| Secure storage and preferences | In-memory fakes. |
| The file picker and file saver | Fakes returning a chosen path, a cancellation, or a refusal. |

### 7.4 Coverage per use case

A use case is covered when its **main flow and every applicable `AF-xx`** are exercised, at whichever
layer that flow becomes observable. Each alternative flow maps to at least one named test, and the
test's name says which flow it is:

```dart
test('Given a date more than one day in the future '
     'When the transaction is submitted '
     'Then the form rejects it and explains that a future movement is a rule or a projection '
     '(UC-19 AF-02)', () { … });
```

Citing the flow in the name is what makes an audit of "is every `AF-xx` covered?" a search rather
than a reading.

### 7.5 Coverage expectations

There is **no numeric coverage floor**, deliberately. A percentage target rewards testing what is
easy and says nothing about whether the flows are covered. The standard is instead:

- every main flow and every applicable `AF-xx` of the use case has a test that names it;
- every edge case in the §6.3 checklist has been walked for each unit the use case adds;
- money paths are covered as §6.4 requires.

Coverage is still measured and reported, because an area of the code no test enters is worth
knowing about — it is a signal to read, not a number to satisfy.

## 8. Per-use-case workflow

Apply this every time:

1. Read the use case's flows and the `FR-xx` requirements traced to it.
2. List the production units the implementation adds or changes, and the screens it touches.
3. Write the unit tests: happy path first, then the §6.3 checklist for each unit.
4. Write the widget tests: all four states, then each alternative flow with a visible outcome.
5. Add an integration test where the use case completes a journey worth protecting.
6. Run `flutter analyze` and `flutter test`, and fix until both are clean.
7. Run the integration suite where this use case touched a journey it covers.
8. Confirm every `AF-xx` of the use case appears in a test name, and every unit's checklist was
   walked.

## 9. Running the suites

```bash
flutter test
```

| Suite | Command |
| --- | --- |
| Static analysis | `flutter analyze` |
| Unit and widget | `flutter test` |
| One file | `flutter test test/features/transactions/state/transaction_form_test.dart` |
| With coverage | `flutter test --coverage` |
| Integration, desktop | `flutter test integration_test -d windows` (or `-d linux`) |
| Integration, web | `flutter test integration_test -d chrome` |

Unit and widget tests share one runner and are separated by **location**, not by tag: `test/`
mirrors `lib/`, and a test's path says what kind it is. Integration tests live in
`integration_test/`, which `flutter test` does not pick up by default — so the fast suite stays
fast, and the slow one is invoked deliberately.

## 10. References

- [Use Case Specification Document](Use%20Case%20Specification%20Document.md) — the flows that must be covered.
- [Development Workflow Document](Development%20Workflow%20Document.md) — when the testing gate applies.
- [Technology Stack Document](Technology%20Stack%20Document.md) — the testing tools and versions.
- [System Requirements Document](System%20Requirements%20Document.md) — the requirements each use case realizes.
