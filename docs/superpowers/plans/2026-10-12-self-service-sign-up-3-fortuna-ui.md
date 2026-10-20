# Self-Service Sign-Up — Plan 3 of 3: fortuna-ui

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the sign-in screen a "Create an account" entry leading to a sign-up screen. That screen offers Google (the existing UC-05 exchange) and a name, email and password form posting to fortuna-api's new `POST /api/auth/register`.

**Architecture:** A new anonymous route `/sign-up` renders `SignUpScreen`. The credential form drives a `SignUpController` (Riverpod `Notifier`) over a `RegistrationRepository` that wraps the regenerated `AuthClient.postApiAuthRegister`. The Google button reuses `SignInController.signInWithGoogle` unchanged, so a first Google sign-in still creates the account and the route guard still routes onward. `SignInScreen` gains one link, outside desktop offline mode.

**Tech Stack:** Flutter, Riverpod, go_router, dio + generated `fortuna_api_client` (swagger_parser + retrofit), flutter_test.

**Spec:** `D:\Repositories\fortuna-ui\docs\superpowers\specs\2026-10-12-self-service-sign-up-design.md` (§6).

**Repository:** `D:\Repositories\fortuna-ui`. Every path below is relative to it.

**Depends on:** Plan 2 (fortuna-api) merged, or at least its `docs/openapi/fortuna.json` final, because Task 1 copies it.

## Global Constraints

- Branch: `feature/self-service-sign-up` (already exists; it holds the spec and these plans). Bring it up to date with `develop` first.
- Commit subjects: lowercase Conventional Commits, ≤ 50 chars, imperative; end every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Test names: `'Given … When … Then …'` as in the existing suites.
- `flutter analyze` must report no issues; an analyzer failure is a failure.
- Never edit `packages/fortuna_api_client/lib` by hand; regenerate with `dart run tool/generate_api_client.dart`.
- Client-side rules mirror Heimdall's and are feedback, not authority: name required, ≤ 200 characters (trimmed); email plausible (`SignInController.isPlausibleEmail`); password ≥ 8 characters.
- The password is never stored in state, never trimmed, and is cleared from its controller on dispose.
- The API's message is shown as worded (`FR-DA-14`, `FR-SE-23`); the success panel shows the API's message, not a client rewording.
- The sign-up link appears only outside desktop offline mode (`FR-CF-07`).
- Use case: **UC-47: Sign Up**. Requirements: **FR-SE-24 … FR-SE-26**.

## Review Focus

1. **Double-tapping "Create account"** — one request; the button is disabled while submitting. Pinned in Task 4.
2. **An instance answering 503 (Heimdall down)** — a retry is offered, as for an unreachable instance. Pinned in Task 3.
3. **A signed-in user opening `/sign-up` by URL** — sent to their home, never shown the form. Pinned in Task 4.
4. **A name of only spaces** — rejected in the form, nothing submitted. Pinned in Task 3.
5. **Desktop offline mode** — no sign-up link on sign-in. Pinned in Task 5.

---

### Task 1: Contract and regenerated client

**Files:**
- Modify: `api/fortuna.json` (copied)
- Modify: `packages/fortuna_api_client/lib/**` (generated)

**Interfaces:**
- Produces: `AuthClient.postApiAuthRegister({RegisterThroughApiCommand? body})` returning `Future<RegisterThroughApiCommandOutputDataOutput>`; `RegisterThroughApiCommand({name, email, password})`.

- [ ] **Step 1: Copy the contract**

```bash
cp ../fortuna-api/docs/openapi/fortuna.json api/fortuna.json
```

Run: `git diff --stat api/fortuna.json`
Expected: one file changed; the diff adds `/api/auth/register` and the `RegisterThroughApiCommand` / `RegisterThroughApiCommandOutput` schemas.

- [ ] **Step 2: Regenerate the client**

Run: `dart run tool/generate_api_client.dart`
Expected: completes without error.

Run: `grep -n "postApiAuthRegister" packages/fortuna_api_client/lib/clients/auth_client.dart`
Expected: one declaration under `@POST('/api/auth/register')`.

Run: `grep -rn "class RegisterThroughApiCommand" packages/fortuna_api_client/lib`
Expected: the command and its output's `DataOutput` wrapper exist. Note the generated constructor's parameter names; Task 2 uses `name:`, `email:`, `password:`.

- [ ] **Step 3: Analyze and run the suite**

Run: `flutter analyze`
Expected: No issues found.
Run: `flutter test`
Expected: all pass — nothing uses the new client yet.

- [ ] **Step 4: Commit**

```bash
git add api packages/fortuna_api_client
git commit -m "build: regenerate the api client for sign-up" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: `RegistrationRepository`

**Files:**
- Create: `lib/features/auth/data/registration_repository.dart`
- Test: `test/features/auth/registration_repository_test.dart`

**Interfaces:**
- Consumes: `AuthClient.postApiAuthRegister`, `RegisterThroughApiCommand` (Task 1); `failureFromDioException`, `dioProvider` (`lib/core/network/api_client.dart`); `Result`, `Success`, `Failure`, `FailureKind`.
- Produces:
  ```dart
  abstract interface class RegistrationRepository {
    Future<Result<String>> register({required String name, required String email, required String password});
  }
  final registrationRepositoryProvider = Provider<RegistrationRepository>(...);
  ```

- [ ] **Step 1: Write the failing repository tests**

Create `test/features/auth/registration_repository_test.dart`:

```dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';

/// Answers from memory and remembers what it was sent.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body);

  final int status;
  final String body;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

HttpRegistrationRepository _repository(_Adapter adapter) =>
    HttpRegistrationRepository(
      AuthClient(
        Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
          ..httpClientAdapter = adapter,
      ),
    );

void main() {
  group('HttpRegistrationRepository', () {
    test('Given the API accepts '
        'When registering '
        'Then its own message is returned and the request is the documented shape', () async {
      final adapter = _Adapter(
        202,
        jsonEncode({
          'success': true,
          'data': <String, Object?>{},
          'messages': ['Check your email.'],
          'errors': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(result, const Success('Check your email.'));
      expect(adapter.request!.path, endsWith('/api/auth/register'));
      expect(adapter.request!.method, 'POST');
      final sent = jsonDecode(jsonEncode(adapter.request!.data)) as Map;
      expect(sent['name'], 'New Person');
      expect(sent['email'], 'new@example.com');
      expect(sent['password'], 'a-long-secret');
    });

    test('Given the scope is closed '
        'When registering '
        'Then the API reason is returned as forbidden', () async {
      final adapter = _Adapter(
        403,
        jsonEncode({
          'success': false,
          'errors': ['This instance is not accepting new accounts.'],
          'messages': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(
        result,
        const Failure<String>(
          message: 'This instance is not accepting new accounts.',
          kind: FailureKind.forbidden,
        ),
      );
    });

    test('Given Heimdall is down '
        'When registering '
        'Then a server error carrying the API reason is returned', () async {
      final adapter = _Adapter(
        503,
        jsonEncode({
          'success': false,
          'errors': ['The identity service is temporarily unavailable.'],
          'messages': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).kind, FailureKind.serverError);
      expect(result.message, 'The identity service is temporarily unavailable.');
    });
  });
}
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/features/auth/registration_repository_test.dart`
Expected: FAIL — `registration_repository.dart` does not exist.

- [ ] **Step 3: Implement the repository**

Create `lib/features/auth/data/registration_repository.dart`:

```dart
/// Creating an account with a name, an address and a password (UC-47).
///
/// The API answers a free and a taken address with the same message, and this
/// repository does nothing that could tell them apart — it returns whatever the
/// API said. Only a closed instance, a malformed request or an unreachable one
/// answer differently, and none of those says anything about an address.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

abstract interface class RegistrationRepository {
  /// Asks the instance to create an account (`UC-47` steps 2-4).
  ///
  /// The password is passed here and nowhere else: it is not stored, not
  /// logged, and not retained for a retry.
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  });
}

class HttpRegistrationRepository implements RegistrationRepository {
  HttpRegistrationRepository(this._client);

  factory HttpRegistrationRepository.fromDio(Dio dio) =>
      HttpRegistrationRepository(AuthClient(dio));

  final AuthClient _client;

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.postApiAuthRegister(
        body: RegisterThroughApiCommand(
          name: name,
          email: email,
          password: password,
        ),
      );

      final message = (response.messages ?? const <String>[]).join(' ').trim();

      return Success(
        message.isEmpty
            ? 'If this address can be registered, we have sent it an email. '
                  'Follow it, then sign in.'
            : message,
      );
    } on DioException catch (exception) {
      return failureFromDioException<String>(exception);
    }
  }
}

final registrationRepositoryProvider = Provider<RegistrationRepository>(
  (ref) => HttpRegistrationRepository.fromDio(ref.watch(dioProvider)),
);
```

If Task 1 showed different generated parameter names for `RegisterThroughApiCommand`, use those.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/features/auth/registration_repository_test.dart`
Expected: 3 passed.

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/registration_repository.dart test/features/auth/registration_repository_test.dart
git commit -m "feat: add the registration repository" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: `SignUpController`

**Files:**
- Create: `lib/features/auth/state/sign_up_controller.dart`
- Test: `test/features/auth/sign_up_controller_test.dart`

**Interfaces:**
- Consumes: `RegistrationRepository`, `registrationRepositoryProvider` (Task 2); `SignInController.isPlausibleEmail` (`lib/features/auth/state/sign_in_controller.dart`).
- Produces:
  ```dart
  enum SignUpField { name, email, password }
  sealed class SignUpState { bool get isBusy; String? get message; }
  final class SignUpReady, SignUpSubmitting;
  final class SignUpInvalid(SignUpField field, String reason);
  final class SignUpRefused(String reason);
  final class SignUpUnreachable(String reason);
  final class SignUpAccepted(String message);
  final signUpControllerProvider = NotifierProvider<SignUpController, SignUpState>(...);
  SignUpController.submit({required String name, required String email, required String password}) : Future<void>
  SignUpController.reset() : void
  ```

- [ ] **Step 1: Write the failing controller tests**

Create `test/features/auth/sign_up_controller_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';
import 'package:fortuna_ui/features/auth/state/sign_up_controller.dart';

/// Answers as the API would, and remembers what it was handed.
class FakeRegistration implements RegistrationRepository {
  FakeRegistration([Result<String> Function()? answer])
    : answer = answer ?? (() => const Success('Check your email.'));

  Result<String> Function() answer;
  final List<({String name, String email, String password})> submitted = [];

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    submitted.add((name: name, email: email, password: password));
    return answer();
  }
}

ProviderContainer containerWith(FakeRegistration repository) {
  final container = ProviderContainer(
    overrides: [registrationRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<SignUpState> submit(
  ProviderContainer container, {
  String name = 'New Person',
  String email = 'new@example.com',
  String password = 'a-long-secret',
}) async {
  await container
      .read(signUpControllerProvider.notifier)
      .submit(name: name, email: email, password: password);
  return container.read(signUpControllerProvider);
}

void main() {
  group('SignUpController', () {
    test('Given valid input '
        'When it is submitted '
        'Then the API message is what the user is shown', () async {
      final repository = FakeRegistration(() => const Success('Check your email.'));

      final state = await submit(containerWith(repository));

      expect(state, isA<SignUpAccepted>());
      expect(state.message, 'Check your email.');
      expect(repository.submitted.single.name, 'New Person');
    });

    test('Given surrounding spaces '
        'When it is submitted '
        'Then name and address are trimmed and the password is not', () async {
      final repository = FakeRegistration();

      await submit(
        containerWith(repository),
        name: '  New Person ',
        email: ' new@example.com ',
        password: ' a long secret ',
      );

      final sent = repository.submitted.single;
      expect(sent.name, 'New Person');
      expect(sent.email, 'new@example.com');
      expect(sent.password, ' a long secret ');
    });

    test('Given a name of only spaces '
        'When it is submitted '
        'Then the name field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), name: '   ');

      expect(state, isA<SignUpInvalid>());
      expect((state as SignUpInvalid).field, SignUpField.name);
      expect(repository.submitted, isEmpty);
    });

    test('Given a name of 201 characters '
        'When it is submitted '
        'Then the name field is refused', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), name: 'a' * 201);

      expect((state as SignUpInvalid).field, SignUpField.name);
      expect(repository.submitted, isEmpty);
    });

    test('Given a name of exactly 200 characters '
        'When it is submitted '
        'Then it is sent', () async {
      final repository = FakeRegistration();

      await submit(containerWith(repository), name: 'a' * 200);

      expect(repository.submitted, hasLength(1));
    });

    test('Given a malformed address '
        'When it is submitted '
        'Then the email field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), email: 'nonsense');

      expect((state as SignUpInvalid).field, SignUpField.email);
      expect(repository.submitted, isEmpty);
    });

    test('Given an address of 257 characters '
        'When it is submitted '
        'Then the email field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(
        containerWith(repository),
        email: '${'a' * 245}@example.com', // 245 + 12 = 257
      );

      expect((state as SignUpInvalid).field, SignUpField.email);
      expect(repository.submitted, isEmpty);
    });

    test('Given a seven-character password '
        'When it is submitted '
        'Then the password field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), password: '1234567');

      expect((state as SignUpInvalid).field, SignUpField.password);
      expect(repository.submitted, isEmpty);
    });

    test('Given a closed instance '
        'When it answers '
        'Then its reason is shown without a retry state', () async {
      final repository = FakeRegistration(
        () => const Failure(
          message: 'This instance is not accepting new accounts.',
          kind: FailureKind.forbidden,
        ),
      );

      final state = await submit(containerWith(repository));

      expect(state, isA<SignUpRefused>());
      expect(state.message, 'This instance is not accepting new accounts.');
    });

    for (final kind in [FailureKind.unreachable, FailureKind.serverError]) {
      test('Given a $kind failure '
          'When it answers '
          'Then a retryable state carries the reason', () async {
        final repository = FakeRegistration(
          () => Failure(message: 'Try later.', kind: kind),
        );

        final state = await submit(containerWith(repository));

        expect(state, isA<SignUpUnreachable>());
        expect(state.message, 'Try later.');
      });
    }

    test('Given a refusal on screen '
        'When the user edits a field '
        'Then the message clears', () async {
      final container = containerWith(FakeRegistration());
      await submit(container, email: 'nonsense');

      container.read(signUpControllerProvider.notifier).reset();

      expect(container.read(signUpControllerProvider), isA<SignUpReady>());
    });
  });
}
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/features/auth/sign_up_controller_test.dart`
Expected: FAIL — `sign_up_controller.dart` does not exist.

- [ ] **Step 3: Implement the controller**

Create `lib/features/auth/state/sign_up_controller.dart`:

```dart
/// The sign-up form's decision-making (UC-47).
///
/// The same two rules as sign-in: the password is never held — it arrives as
/// an argument, goes to the repository and is gone — and the API's answer is
/// never interpreted. A free and a taken address get the same reply from the
/// API, and this controller shows that reply as it came.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/registration_repository.dart';
import 'sign_in_controller.dart';

/// Which field a client-side refusal is about, so it can be shown under it.
enum SignUpField { name, email, password }

/// Where the sign-up form is in its work.
@immutable
sealed class SignUpState {
  const SignUpState();

  bool get isBusy => this is SignUpSubmitting;

  /// The text to show, or `null` when there is nothing to say.
  String? get message => switch (this) {
    SignUpInvalid(:final reason) => reason,
    SignUpRefused(:final reason) => reason,
    SignUpUnreachable(:final reason) => reason,
    SignUpAccepted(:final message) => message,
    SignUpReady() || SignUpSubmitting() => null,
  };
}

/// Nothing has been submitted.
@immutable
final class SignUpReady extends SignUpState {
  const SignUpReady();
}

/// The API has not yet answered.
@immutable
final class SignUpSubmitting extends SignUpState {
  const SignUpSubmitting();
}

/// `AF-01`: rejected in the form, nothing submitted.
@immutable
final class SignUpInvalid extends SignUpState {
  const SignUpInvalid(this.field, this.reason);

  final SignUpField field;
  final String reason;
}

/// `AF-02`, `AF-03`: the API refused, and its message is what is shown.
@immutable
final class SignUpRefused extends SignUpState {
  const SignUpRefused(this.reason);

  final String reason;
}

/// `AF-04`: the instance, or the identity service behind it, could not be
/// reached. A retry is offered.
@immutable
final class SignUpUnreachable extends SignUpState {
  const SignUpUnreachable(this.reason);

  final String reason;
}

/// The API accepted the request. Whether an account was created is not
/// something this client is told (`AF-02`).
@immutable
final class SignUpAccepted extends SignUpState {
  const SignUpAccepted(this.message);

  @override
  final String message;
}

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(SignUpController.new);

class SignUpController extends Notifier<SignUpState> {
  /// Heimdall's limits (UC-47). Feedback only; the API decides.
  static const maximumNameLength = 200;
  static const maximumEmailLength = 256;
  static const minimumPasswordLength = 8;

  @override
  SignUpState build() => const SignUpReady();

  /// Clears a refusal, so a correction is not masked by the complaint about
  /// what it corrected. An accepted request stays accepted.
  void reset() {
    if (state is SignUpInvalid ||
        state is SignUpRefused ||
        state is SignUpUnreachable) {
      state = const SignUpReady();
    }
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedName = name.trim();

    // AF-01 — before anything is submitted.
    if (trimmedName.isEmpty) {
      state = const SignUpInvalid(SignUpField.name, 'Enter your name.');
      return;
    }
    if (trimmedName.length > maximumNameLength) {
      state = const SignUpInvalid(
        SignUpField.name,
        'Use a name of $maximumNameLength characters or fewer.',
      );
      return;
    }
    if (!SignInController.isPlausibleEmail(email)) {
      state = const SignUpInvalid(
        SignUpField.email,
        'Enter the email address you want to sign in with.',
      );
      return;
    }
    if (email.trim().length > maximumEmailLength) {
      state = const SignUpInvalid(
        SignUpField.email,
        'Use an email address of $maximumEmailLength characters or fewer.',
      );
      return;
    }
    if (password.length < minimumPasswordLength) {
      state = const SignUpInvalid(
        SignUpField.password,
        'Use a password of at least $minimumPasswordLength characters.',
      );
      return;
    }

    state = const SignUpSubmitting();

    final result = await ref
        .read(registrationRepositoryProvider)
        .register(name: trimmedName, email: email.trim(), password: password);

    state = switch (result) {
      Success(:final value) => SignUpAccepted(value),
      // A 503 is Heimdall being down behind a reachable instance — as worth
      // retrying as an instance that did not answer at all.
      Failure(:final message, kind: FailureKind.unreachable) ||
      Failure(:final message, kind: FailureKind.serverError) =>
        SignUpUnreachable(message),
      Failure(:final message) => SignUpRefused(message),
    };
  }
}
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/features/auth/sign_up_controller_test.dart`
Expected: 12 passed.

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/state/sign_up_controller.dart test/features/auth/sign_up_controller_test.dart
git commit -m "feat: add the sign-up controller" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: `SignUpScreen` and the `/sign-up` route

**Files:**
- Create: `lib/features/auth/ui/sign_up_screen.dart`
- Modify: `lib/app/routes.dart`, `lib/app/router.dart`
- Test: `test/features/auth/sign_up_screen_test.dart`
- Test: `test/app/route_guard_test.dart`

**Interfaces:**
- Consumes: `signUpControllerProvider`, `SignUpState` subclasses, `SignUpField` (Task 3); `signInControllerProvider.notifier.signInWithGoogle`, `googleIdentityServiceProvider`.
- Produces: `Routes.signUp = '/sign-up'` (in `Routes.anonymous`); `SignUpScreen({VoidCallback? onSignIn})`; widget keys `signUp.name`, `signUp.email`, `signUp.password`, `signUp.reveal`, `signUp.submit`, `signUp.google`, `signUp.retry`, `signUp.done`, `signUp.signIn`.

- [ ] **Step 1: Write the failing widget tests**

Create `test/features/auth/sign_up_screen_test.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/auth/data/credentials_repository.dart';
import 'package:fortuna_ui/features/auth/data/google_identity.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';
import 'package:fortuna_ui/features/auth/ui/sign_up_screen.dart';

import 'google_sign_in_test.dart' show FakeGoogle;
import 'sign_in_controller_test.dart' show FakeCredentials, tokenFor;
import 'sign_up_controller_test.dart' show FakeRegistration;

Future<void> pumpSignUp(
  WidgetTester tester, {
  required RegistrationRepository registration,
  GoogleIdentityService? google,
  FakeCredentials? credentials,
  VoidCallback? onSignIn,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            apiBaseUrl: 'https://fortuna.example',
            googleClientId: google == null ? '' : 'client-id',
            transport: Transport.http,
            databasePath: '',
          ),
        ),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
        coreLibraryProbeProvider.overrideWithValue(
          const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
        ),
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
        registrationRepositoryProvider.overrideWithValue(registration),
        credentialsRepositoryProvider.overrideWithValue(
          credentials ??
              FakeCredentials(
                (_, _) => Success(
                  SignInGranted(token: tokenFor(), emailVerified: true),
                ),
              ),
        ),
        if (google != null)
          googleIdentityServiceProvider.overrideWithValue(google),
      ],
      child: MaterialApp(home: SignUpScreen(onSignIn: onSignIn)),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> fillForm(
  WidgetTester tester, {
  String name = 'New Person',
  String email = 'new@example.com',
  String password = 'a-long-secret',
}) async {
  await tester.enterText(find.byKey(const Key('signUp.name')), name);
  await tester.enterText(find.byKey(const Key('signUp.email')), email);
  await tester.enterText(find.byKey(const Key('signUp.password')), password);
}

void main() {
  group('SignUpScreen', () {
    testWidgets('Given the screen is shown '
        'When it settles '
        'Then the three fields and the submit action are offered, and no Google '
        'option where none is configured', (tester) async {
      await pumpSignUp(tester, registration: FakeRegistration());

      expect(find.byKey(const Key('signUp.name')), findsOneWidget);
      expect(find.byKey(const Key('signUp.email')), findsOneWidget);
      expect(find.byKey(const Key('signUp.password')), findsOneWidget);
      expect(find.byKey(const Key('signUp.submit')), findsOneWidget);
      expect(find.byKey(const Key('signUp.google')), findsNothing);
    });

    testWidgets('Given the password field '
        'When the screen is shown '
        'Then it is obscured until the user asks otherwise', (tester) async {
      await pumpSignUp(tester, registration: FakeRegistration());

      TextField password() =>
          tester.widget<TextField>(find.byKey(const Key('signUp.password')));

      expect(password().obscureText, isTrue);
      await tester.tap(find.byKey(const Key('signUp.reveal')));
      await tester.pumpAndSettle();
      expect(password().obscureText, isFalse);
    });

    testWidgets('Given a short password '
        'When it is submitted '
        'Then the reason is shown under the password field and nothing is sent', (
      tester,
    ) async {
      final registration = FakeRegistration();
      await pumpSignUp(tester, registration: registration);

      await fillForm(tester, password: '1234567');
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(
        find.byKey(const Key('signUp.password')),
      );
      expect(field.decoration!.errorText, contains('at least 8'));
      expect(registration.submitted, isEmpty);
    });

    testWidgets('Given the API accepts '
        'When the form is submitted '
        'Then the form is replaced by the API message and a way back to sign in', (
      tester,
    ) async {
      var backToSignIn = 0;
      await pumpSignUp(
        tester,
        registration: FakeRegistration(() => const Success('Check your email.')),
        onSignIn: () => backToSignIn++,
      );

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();

      expect(find.text('Check your email.'), findsOneWidget);
      expect(find.byKey(const Key('signUp.name')), findsNothing);
      await tester.tap(find.byKey(const Key('signUp.done')));
      expect(backToSignIn, 1);
    });

    testWidgets('Given a closed instance '
        'When it answers '
        'Then its reason is shown and no retry is offered', (tester) async {
      await pumpSignUp(
        tester,
        registration: FakeRegistration(
          () => const Failure(
            message: 'This instance is not accepting new accounts.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();

      expect(
        find.text('This instance is not accepting new accounts.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('signUp.retry')), findsNothing);
    });

    testWidgets('Given Heimdall is down '
        'When it answers '
        'Then a retry is offered and resubmits', (tester) async {
      final registration = FakeRegistration(
        () => const Failure(
          message: 'The identity service is temporarily unavailable.',
          kind: FailureKind.serverError,
        ),
      );
      await pumpSignUp(tester, registration: registration);

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('signUp.retry')));
      await tester.pumpAndSettle();

      expect(registration.submitted, hasLength(2));
    });

    testWidgets('Given a request in flight '
        'When submit is tapped again '
        'Then only one request is sent', (tester) async {
      final pending = Completer<Result<String>>();
      final registration = _PendingRegistration(pending.future);
      await pumpSignUp(tester, registration: registration);

      await fillForm(tester);
      await tester.tap(find.byKey(const Key('signUp.submit')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('signUp.submit')), warnIfMissed: false);
      await tester.pump();

      expect(registration.calls, 1);
      pending.complete(const Success('Check your email.'));
      await tester.pumpAndSettle();
    });

    testWidgets('Given Google is configured '
        'When "Continue with Google" is tapped '
        'Then the existing Google exchange runs', (tester) async {
      final google = FakeGoogle(const GoogleIdentityObtained('id-token'));
      final credentials = FakeCredentials(
        (_, _) => Success(SignInGranted(token: tokenFor(), emailVerified: true)),
      )..googleAnswer =
            (_) => Success(SignInGranted(token: tokenFor(), emailVerified: true));
      await pumpSignUp(
        tester,
        registration: FakeRegistration(),
        google: google,
        credentials: credentials,
      );

      await tester.tap(find.byKey(const Key('signUp.google')));
      await tester.pumpAndSettle();

      expect(google.attempts, 1);
      expect(credentials.exchangedIdTokens, ['id-token']);
    });

    testWidgets('Given "Already have an account?" '
        'When it is tapped '
        'Then the screen asks to go to sign in', (tester) async {
      var backToSignIn = 0;
      await pumpSignUp(
        tester,
        registration: FakeRegistration(),
        onSignIn: () => backToSignIn++,
      );

      await tester.tap(find.byKey(const Key('signUp.signIn')));

      expect(backToSignIn, 1);
    });
  });
}

/// Holds its answer until the test releases it, counting calls meanwhile.
class _PendingRegistration implements RegistrationRepository {
  _PendingRegistration(this.answer);

  final Future<Result<String>> answer;
  int calls = 0;

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) {
    calls++;
    return answer;
  }
}
```

(`instance_config.dart` declares `appConfigProvider`, `preferencesStoreProvider` and `coreLibraryProbeProvider`; `session_controller.dart` declares `tokenStoreProvider`.)

Add to `test/app/route_guard_test.dart`, inside `group('resolveRedirect', …)`:

```dart
    test('Given no session '
        'When sign-up is requested '
        'Then it is admitted (UC-47)', () {
      expect(
        redirect(
          instance: _configured,
          session: const SignedOut(),
          location: Routes.signUp,
        ),
        isNull,
      );
    });

    test('Given a signed-in owner '
        'When sign-up is requested '
        'Then they are sent home rather than shown the form', () {
      expect(
        redirect(
          instance: _configured,
          session: _owner,
          location: Routes.signUp,
        ),
        Routes.home,
      );
    });
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/features/auth/sign_up_screen_test.dart test/app/route_guard_test.dart`
Expected: FAIL — `sign_up_screen.dart` and `Routes.signUp` do not exist.

- [ ] **Step 3: Add the route**

In `lib/app/routes.dart`, after `signIn`:

```dart
  /// Creating an account with a name, an address and a password, or with
  /// Google (`UC-47`). Anonymous for the obvious reason.
  static const signUp = '/sign-up';
```

and add `signUp,` to `Routes.anonymous` after `signIn,`.

In `lib/app/router.dart`, import `'../features/auth/ui/sign_up_screen.dart'` and add after the `Routes.signIn` route:

```dart
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) =>
            SignUpScreen(onSignIn: () => context.go(Routes.signIn)),
      ),
```

- [ ] **Step 4: Implement the screen**

Create `lib/features/auth/ui/sign_up_screen.dart`:

```dart
/// The sign-up screen (UC-47).
///
/// Two ways in. Google is the existing UC-05 exchange, untouched: a first
/// Google sign-in creates the account, grants a session, and the guard routes
/// onward as it does from sign-in. The credential form asks the instance to
/// create an account and then says what the instance said — which is the same
/// whether the address was free or already taken, so the next step is always
/// the same too: check the inbox, then sign in.
///
/// The fields are cleared when the screen goes away, and the password is never
/// kept anywhere else.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/google_identity.dart';
import '../state/sign_in_controller.dart';
import '../state/sign_up_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({this.onSignIn, super.key});

  /// Back to sign-in, once the account is requested or if the user has one.
  final VoidCallback? onSignIn;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _obscured = true;

  @override
  void dispose() {
    _name.clear();
    _email.clear();
    _password.clear();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    unawaited(
      ref
          .read(signUpControllerProvider.notifier)
          .submit(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          ),
    );
  }

  void _reset(String _) => ref.read(signUpControllerProvider.notifier).reset();

  String? _errorFor(SignUpState state, SignUpField field) =>
      state is SignUpInvalid && state.field == field ? state.reason : null;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final google = ref.watch(signInControllerProvider);
    final googleAvailable = ref.watch(googleIdentityServiceProvider) != null;
    final busy = state.isBusy || google.isBusy;
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create an account',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (state case SignUpAccepted(:final message)) ...[
                  _Panel(message: message, isError: false),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('signUp.done'),
                    onPressed: widget.onSignIn,
                    child: const Text('Back to sign in'),
                  ),
                ] else ...[
                  TextField(
                    key: const Key('signUp.name'),
                    controller: _name,
                    autofocus: true,
                    enabled: !busy,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.name),
                    ),
                    onChanged: _reset,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('signUp.email'),
                    controller: _email,
                    enabled: !busy,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.email),
                    ),
                    onChanged: _reset,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('signUp.password'),
                    controller: _password,
                    enabled: !busy,
                    obscureText: _obscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'At least 8 characters.',
                      border: const OutlineInputBorder(),
                      errorText: _errorFor(state, SignUpField.password),
                      suffixIcon: IconButton(
                        key: const Key('signUp.reveal'),
                        onPressed: () => setState(() => _obscured = !_obscured),
                        icon: Icon(
                          _obscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscured ? 'Show password' : 'Hide password',
                      ),
                    ),
                    onChanged: _reset,
                    onSubmitted: (_) => busy ? null : _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('signUp.submit'),
                    onPressed: busy ? null : _submit,
                    child: state.isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
                  ),

                  if (googleAvailable) ...[
                    const SizedBox(height: 16),
                    const _OrDivider(),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      key: const Key('signUp.google'),
                      onPressed: busy
                          ? null
                          : ref
                                .read(signInControllerProvider.notifier)
                                .signInWithGoogle,
                      icon: const Icon(Icons.account_circle_outlined),
                      label: const Text('Continue with Google'),
                    ),
                  ],

                  if (state case SignUpRefused(:final reason)) ...[
                    const SizedBox(height: 16),
                    _Panel(message: reason, isError: true),
                  ],
                  if (state case SignUpUnreachable(:final reason)) ...[
                    const SizedBox(height: 16),
                    _Panel(message: reason, isError: true, onRetry: _submit),
                  ],
                  if (google.message case final message?) ...[
                    const SizedBox(height: 16),
                    _Panel(message: message, isError: true),
                  ],

                  const SizedBox(height: 8),
                  TextButton(
                    key: const Key('signUp.signIn'),
                    onPressed: widget.onSignIn,
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.message, required this.isError, this.onRetry});

  final String message;
  final bool isError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = isError
        ? scheme.errorContainer
        : scheme.secondaryContainer;
    final foreground = isError
        ? scheme.onErrorContainer
        : scheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.mark_email_read_outlined,
                size: 20,
                color: foreground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: TextStyle(color: foreground)),
              ),
            ],
          ),
          if (onRetry != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('signUp.retry'),
                onPressed: onRetry,
                child: const Text('Try again'),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or', style: Theme.of(context).textTheme.bodySmall),
      ),
      const Expanded(child: Divider()),
    ],
  );
}
```

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/features/auth/sign_up_screen_test.dart test/app/route_guard_test.dart test/app/router_test.dart`
Expected: all pass.

- [ ] **Step 6: Commit**

```bash
git add lib/app lib/features/auth/ui/sign_up_screen.dart test/features/auth/sign_up_screen_test.dart test/app/route_guard_test.dart
git commit -m "feat: add the sign-up screen and route" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: The link on the sign-in screen

**Files:**
- Modify: `lib/features/auth/ui/sign_in_screen.dart`
- Test: `test/features/auth/sign_in_screen_test.dart`

**Interfaces:**
- Consumes: `Routes.signUp` (Task 4); `instanceConfigProvider`, `AppMode`.
- Produces: widget key `signIn.signUp`.

- [ ] **Step 1: Write the failing tests**

Add to `test/features/auth/sign_in_screen_test.dart` (imports: `package:go_router/go_router.dart`, `package:fortuna_ui/app/routes.dart`):

```dart
  group('SignInScreen sign-up link', () {
    testWidgets('Given a connected installation '
        'When "Create an account" is tapped '
        'Then the sign-up route is opened (UC-47)', (tester) async {
      final router = GoRouter(
        initialLocation: Routes.signIn,
        routes: [
          GoRoute(
            path: Routes.signIn,
            builder: (context, state) => const SignInScreen(),
          ),
          GoRoute(
            path: Routes.signUp,
            builder: (context, state) => const Text('sign-up route'),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(
              const AppConfig(
                apiBaseUrl: 'https://fortuna.example',
                googleClientId: '',
                transport: Transport.http,
                databasePath: '',
              ),
            ),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
            coreLibraryProbeProvider.overrideWithValue(
              const FixedCoreLibraryProbe(CoreLibraryAvailability.absent),
            ),
            tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('signIn.signUp')));
      await tester.pumpAndSettle();

      expect(find.text('sign-up route'), findsOneWidget);
    });

    testWidgets('Given desktop offline mode '
        'When sign-in is shown '
        'Then no sign-up link is offered (FR-CF-07)', (tester) async {
      // An FFI build whose core loads starts in AppMode.desktopOffline.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(
              const AppConfig(
                apiBaseUrl: '',
                googleClientId: '',
                transport: Transport.ffi,
                databasePath: 'fortuna.db',
              ),
            ),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
            coreLibraryProbeProvider.overrideWithValue(
              const FixedCoreLibraryProbe(CoreLibraryAvailability.available),
            ),
            tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
          ],
          child: const MaterialApp(home: SignInScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('signIn.recover')), findsOneWidget);
      expect(find.byKey(const Key('signIn.signUp')), findsNothing);
    });
  });
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/features/auth/sign_in_screen_test.dart`
Expected: the connected-installation test FAILS — no widget with key `signIn.signUp`.

- [ ] **Step 3: Add the link**

In `sign_in_screen.dart`, import `'../../../core/config/instance_config.dart'`. In `build`, read the mode:

```dart
    final offline =
        ref.watch(instanceConfigProvider).mode == AppMode.desktopOffline;
```

and after the `signIn.recover` `TextButton`:

```dart
                // UC-47. Offline, the local account has its own creation path
                // (UC-06) and there is no instance to register with (FR-CF-07).
                if (!offline)
                  TextButton(
                    key: const Key('signIn.signUp'),
                    onPressed: () => context.push(Routes.signUp),
                    child: const Text('New to Fortuna? Create an account'),
                  ),
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/features/auth/sign_in_screen_test.dart`
Expected: all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/ui/sign_in_screen.dart test/features/auth/sign_in_screen_test.dart
git commit -m "feat: link sign-in to sign-up" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Documentation, backlog and verification

**Files:**
- Modify: `docs/requirements/Use Case Specification Document.md`, `docs/requirements/System Requirements Document.md`, `docs/requirements/Vision Document.md`
- Modify: `README.md`, `CHANGELOG.md`

- [ ] **Step 1: Add UC-47**

After the UC-46 section of the Use Case Specification, add:

```markdown
### UC-47: Sign Up

| Field | Value |
| --- | --- |
| **ID** | UC-47 |
| **Name** | Sign Up |
| **Actors** | Account Owner, Google Sign-In, Fortuna API |
| **Description** | Create an account from the sign-in screen, with Google or with a name, an email address and a password |
| **Preconditions** | The instance is configured and reachable; the mode is connected or self-hosted |
| **Postconditions** | With Google: a session is held and the account exists (UC-05). With credentials: the instance has accepted the request, and the user has been told to check their email and then sign in |
| **Requirements** | FR-SE-02, FR-SE-24, FR-SE-25, FR-SE-26 |

**Main Flow**

1. The user chooses "Create an account" on the sign-in screen.
2. The user enters a name, an email address and a password, and submits.
3. The system checks the input against the instance's rules and submits it.
4. The system replaces the form with the instance's answer and a way back to sign-in.
5. The user follows the verification email and signs in (UC-03).

**Alternative Flows**

| ID | Condition | Outcome |
| --- | --- | --- |
| AF-01 | A field is empty, the name too long, the address implausible, or the password shorter than 8 characters | Rejected in the form, under the field concerned; nothing is submitted |
| AF-02 | The address already has an account | The same answer as a new address; the account's holder is emailed by the instance |
| AF-03 | The instance does not accept new accounts | The system presents the API's reason |
| AF-04 | The instance or its identity service cannot be reached | The system presents the reason and offers a retry; the password is retyped, never replayed |
| AF-05 | The user chooses Google | UC-05 runs unchanged: a first Google sign-in creates the account |
| AF-06 | Desktop offline mode | The option is not offered; UC-06 creates the local account |
```

- [ ] **Step 2: Requirements and vision**

In `System Requirements Document.md`, after `FR-SE-23`:

```markdown
| FR-SE-24 | The system shall offer account creation from the sign-in screen outside desktop offline mode, with Google and with a name, an email address and a password. |
| FR-SE-25 | The system shall present the API's answer to a credential sign-up as worded, without distinguishing a new address from a registered one. |
| FR-SE-26 | The system shall check a credential sign-up against the instance's rules before submitting it — a name of at most 200 characters, a plausible address, a password of at least 8 characters — and shall show each refusal under its field. |
```

Change the two ranges that read `FR-SE-01 … FR-SE-23` and `FR-SE-16 through FR-SE-23` to end at `FR-SE-26`. Add the route `/sign-up` to §5's route table next to `/sign-in`, marked anonymous and implemented by UC-47.

In `Vision Document.md`, F-01: replace "Sign-up is the first Google sign-in." with "Sign up with Google — a first Google sign-in — or with a name, an email address and a password."

- [ ] **Step 3: Backlog and changelog**

Ask the user before running (it publishes to GitHub):

```bash
gh issue create --repo artur-rios/fortuna-ui --title "UC-47 — Sign Up" --body "Sign-up screen linked from sign-in: Google (UC-05) and credentials (fortuna-api UC-81). See UC-47 in docs/requirements/Use Case Specification Document.md."
```

README backlog, after the UC-46 row:

```markdown
| [#<n>](https://github.com/artur-rios/fortuna-ui/issues/<n>) | ✅ | UC-47 — Sign Up | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
```

`CHANGELOG.md`, `## [Unreleased]` → `### Added`:

```markdown
- UC-47: "Create an account" on the sign-in screen opens a sign-up screen offering Google and a name, email and password form.
```

- [ ] **Step 4: Full verification**

Run: `flutter analyze`
Expected: No issues found.
Run: `flutter test`
Expected: all pass.
Run: `dart run tool/generate_api_client.dart` then `git status --porcelain packages/fortuna_api_client api`
Expected: no output (no drift).

- [ ] **Step 5: See it working**

Run the app against a local fortuna-api + Heimdall with self-registration opened for Fortuna's scope (`PUT /api/scopes/{FORTUNA_HEIMDALL_SCOPE_ID}/self-registration {"enabled": true}` as a System Admin). Check: sign-in shows the link; the form registers; the success panel appears; with the scope closed, the 403 message appears.

- [ ] **Step 6: Commit and open the pull request**

```bash
git add docs README.md CHANGELOG.md
git commit -m "docs: specify sign-up (uc-47)" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -u origin feature/self-service-sign-up
gh pr create --repo artur-rios/fortuna-ui --base develop --title "feat: sign-up from the sign-in screen (UC-47)" --body "Implements UC-47 per docs/superpowers/specs/2026-10-12-self-service-sign-up-design.md §6. Depends on fortuna-api UC-81 and heimdall-api UC-47.

🤖 Generated with [Claude Code](https://claude.com/claude-code)"
```

Pushing and opening the PR are outward-facing: confirm with the user first.

---

## Amendment (2026-10-13): confirmation needs the sign-up password

The Heimdall and fortuna-api branches settled the confirmation contract (spec §4.3a): signing up writes a
*pending* registration and mails a link; **no account exists until the link is followed with the password
chosen at sign-up**. `POST /api/auth/verify-email { token, password? }` answers:

| Situation | Status | Message (exact) |
| --- | --- | --- |
| plain verification token, or sign-up token + right password | 200 | the API's success message |
| sign-up token, no password | **422** | `Enter the password you chose when you signed up to finish creating your account.` |
| sign-up token, wrong password | **401** | `That password does not match the one chosen when signing up.` |
| bad / expired / used link, or after the 10th wrong password | 400 | the API's generic message |

Two consequences for this repository, found by the fortuna-api final review:
- `ApiClientFactory`'s `onError` calls `onUnauthenticated` — which ends the session with "Your session
  expired" — on **every** 401. A wrong confirmation password (and, today, a wrong sign-in password) is a 401
  from an anonymous route that has nothing to do with the session.
- `failureFromDioException` maps 400 and 422 to the same `FailureKind.invalidInput`, so a screen cannot tell
  "needs the password" from "bad link" by kind.

**Execution order:** Tasks 1-5, then **7**, then **8**, then 6 (Task 6's docs also cover Tasks 7-8).

**Amended constraints:**
- The verify screen still submits a link's token by itself on load (plain verification links keep working
  unchanged); when the answer is 422 it asks for the password and only an explicit **"Create my account"**
  button submits it. A wrong password keeps the form and shows the API's message under the field.
- A 401 from an anonymous auth route never ends the session.
- Sign-up also refuses an email longer than 256 characters (Task 3, already amended in place).

---

### Task 7: A 401 from an anonymous auth route does not end the session

**Files:**
- Modify: `lib/core/network/api_client.dart`
- Test: `test/core/network/api_client_test.dart`

**Interfaces:**
- Produces: `const anonymousAuthPaths = <String>{ … }` (top-level, documented) and the rule "call `onUnauthenticated` on a 401 only when the request path is not in `anonymousAuthPaths`".

- [ ] **Step 1: Failing tests** — in `api_client_test.dart`, build a `Dio` with `ApiClientFactory(...).create()` (see how the file builds one today) whose adapter answers 401, record `onUnauthenticated` calls, and assert:
  - `POST /api/auth/verify-email` → 401: **not** called;
  - `POST /api/auth/login` → 401: **not** called;
  - `POST /api/auth/register` → 401: not called;
  - `GET /api/accounts` → 401: called once (the existing behaviour, kept).
- [ ] **Step 2: Implement**

```dart
/// Routes a caller reaches without a session (`UC-03`, `UC-04`, `UC-05`, `UC-09`,
/// `UC-47`). A 401 from one of them is the API refusing what was submitted — a
/// password, a code, a confirmation — never the API rejecting a session token,
/// so it must not end the session (`FR-SE-19` is about the latter).
const anonymousAuthPaths = <String>{
  '/api/auth/login',
  '/api/auth/google',
  '/api/auth/2fa/verify',
  '/api/auth/2fa/challenge/resend',
  '/api/auth/password-recovery',
  '/api/auth/password-reset',
  '/api/auth/verify-email',
  '/api/auth/register',
};
```

and in `onError`:

```dart
        onError: (error, handler) {
          final anonymous = anonymousAuthPaths.contains(error.requestOptions.path);
          if (error.response?.statusCode == 401 && !anonymous) {
            onUnauthenticated?.call();
          }
          handler.next(error);
        },
```

(If `requestOptions.path` is a full URL in this setup, compare `Uri.parse(path).path` — check what the existing tests' adapter sees and use the form that matches.)

- [ ] **Step 3: Run** `flutter test test/core/network/api_client_test.dart test/features/auth` — all pass. **Commit:**

```bash
git add lib/core/network/api_client.dart test/core/network/api_client_test.dart
git commit -m "fix: keep the session on anonymous auth 401s" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: The verify screen asks for the sign-up password

**Files:**
- Modify: `lib/features/auth/data/account_recovery_repository.dart`
- Modify: `lib/features/auth/state/account_recovery_controller.dart`
- Modify: `lib/features/auth/ui/password_recovery_screen.dart` (`VerifyEmailScreen`)
- Test: `test/features/auth/account_recovery_test.dart`

**Interfaces:**
- Consumes: the regenerated `VerifyEmailThroughApiCommand` (Task 1) — it now has an optional `password`.
- Produces:
  ```dart
  sealed class VerifyEmailAnswer { final String message; }
  final class VerifyEmailConfirmed extends VerifyEmailAnswer;      // 200
  final class VerifyEmailPasswordNeeded extends VerifyEmailAnswer; // 422
  final class VerifyEmailPasswordWrong extends VerifyEmailAnswer;  // 401
  AccountRecoveryRepository.verifyEmail(String token, {String? password}) : Future<Result<VerifyEmailAnswer>>
  final class RecoveryNeedsPassword extends RecoveryState { final String message; final String? error; }
  AccountRecoveryController.confirmRegistration({required String token, required String password}) : Future<void>
  ```
  Widget keys: `verify.password`, `verify.confirm`, `verify.passwordNeeded`.

- [ ] **Step 1: Failing tests** (extend `FakeRecovery` so `verifyEmail` takes `{String? password}` and returns `Result<VerifyEmailAnswer>`; keep its recording of what was submitted):
  - controller: a plain token answering `VerifyEmailConfirmed` → `RecoveryDone` (unchanged behaviour);
  - controller: `VerifyEmailPasswordNeeded` → `RecoveryNeedsPassword(message, error: null)`;
  - controller: `confirmRegistration` with a wrong password → `RecoveryNeedsPassword(message: <the original prompt>, error: <the API's wrong-password message>)`, and the password was sent;
  - controller: `confirmRegistration` with an empty password → stays `RecoveryNeedsPassword` with `error: 'Enter your password.'` and nothing is sent;
  - controller: a 400 failure → `RecoveryRefused` whose reason is the API's message followed by the hint `If this link came from signing up, sign up again — or sign in if you already finished.`;
  - repository (with an adapter like `registration_repository_test.dart`'s): 200 → `VerifyEmailConfirmed(apiMessage)`; 422 → `Success(VerifyEmailPasswordNeeded(apiError))`; 401 → `Success(VerifyEmailPasswordWrong(apiError))`; 400 → `Failure(invalidInput)`; the request body carries `password` only when one is given;
  - widget: a token whose answer is `PasswordNeeded` shows the prompt, an obscured `verify.password` field and a `verify.confirm` button **and nothing is submitted a second time by itself**; tapping `verify.confirm` with a password submits `{token, password}` once; a wrong password shows the API's message as the field's `errorText` and keeps the form; success shows `verify.done`; the "Send the verification email again" button is not shown while the password is asked for.
- [ ] **Step 2: Implement**
  - Repository: `verifyEmail(String token, {String? password})` sends `VerifyEmailThroughApiCommand(token: token, password: password)`. On success → `Success(VerifyEmailConfirmed(_messageOr(...)))`. In the `DioException` handler: status 422 → `Success(VerifyEmailPasswordNeeded(message))`, 401 → `Success(VerifyEmailPasswordWrong(message))`, where `message` is the API's error (`failureFromDioException(exception).message`); otherwise `failureFromDioException`. Document why 422/401 are *answers* here rather than failures: both mean "the link is good; the password is the question".
  - Controller: `verifyEmail(token)` maps `VerifyEmailConfirmed` → `RecoveryDone`, `VerifyEmailPasswordNeeded` → `RecoveryNeedsPassword(message)`, `VerifyEmailPasswordWrong` (cannot happen without a password) → `RecoveryNeedsPassword(message)`; `Failure` → `RecoveryRefused('${message} If this link came from signing up, sign up again — or sign in if you already finished.', canRequestAnother: true)`. New `confirmRegistration({token, password})`: empty → `RecoveryNeedsPassword(prompt, error: 'Enter your password.')`; else `RecoveryWorking`, then `verifyEmail(token.trim(), password: password)` (password not trimmed) and map: confirmed → `RecoveryDone`; wrong → `RecoveryNeedsPassword(prompt, error: message)`; needed → `RecoveryNeedsPassword(message)`; failure → as above. Keep the prompt text of the last `RecoveryNeedsPassword` so a wrong password does not replace it. The password is never stored in state.
  - Screen: when `state is RecoveryNeedsPassword` show `_Notice(key: verify.passwordNeeded, message: state.message, tone: neutral)`, a `TextField(key: verify.password, obscureText: true, errorText: state.error)`, and `FilledButton(key: verify.confirm, child: Text('Create my account'))` calling `confirmRegistration(token: widget.token, password: controller.text)`; disable while busy; clear the field controller in `dispose`. Hide the resend button in this state. `VerifyEmailScreen` becomes stateful about the password field only (it already is a `ConsumerStatefulWidget`).
  - Update callers/fakes of `verifyEmail` elsewhere (grep).
- [ ] **Step 3: Run** `flutter test test/features/auth` and `flutter analyze` — clean. **Commit:**

```bash
git add lib/features/auth test/features/auth
git commit -m "feat: ask for the sign-up password to confirm" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6 additions (docs)

Besides Task 6's own items: UC-47 gains the confirmation steps (follow the link → enter the sign-up password → "Create my account"; 422 → asked; 401 → the API's message under the field; 400 → message plus the sign-up hint) and the AF for a 401 from an anonymous route not ending the session; **FR-SE-27** "The system shall ask for the password chosen at sign-up when a confirmation link requires it, and submit it only on the user's explicit action"; **FR-SE-28** "A 401 from an anonymous authentication route shall not end the session". Update FR-SE ranges to 28.
