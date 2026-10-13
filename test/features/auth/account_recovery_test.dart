import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/account_recovery_repository.dart';
import 'package:fortuna_ui/features/auth/state/account_recovery_controller.dart';
import 'package:fortuna_ui/features/auth/ui/password_recovery_screen.dart';

class FakeRecovery implements AccountRecoveryRepository {
  FakeRecovery({this.onRequest, this.onReset, this.onVerify, this.onResend});

  Result<String> Function(String email)? onRequest;
  Result<String> Function(String token, String newPassword)? onReset;
  Result<VerifyEmailAnswer> Function(String token, String? password)? onVerify;
  Result<String> Function()? onResend;

  final List<String> requested = [];
  final List<({String token, String password})> resets = [];
  final List<String> verified = [];
  final List<({String token, String? password})> verifications = [];
  int resends = 0;

  @override
  Future<Result<String>> requestPasswordRecovery(String email) async {
    requested.add(email);
    return onRequest?.call(email) ?? const Success('sent');
  }

  @override
  Future<Result<String>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    resets.add((token: token, password: newPassword));
    return onReset?.call(token, newPassword) ?? const Success('reset');
  }

  @override
  Future<Result<VerifyEmailAnswer>> verifyEmail(
    String token, {
    String? password,
  }) async {
    verified.add(token);
    verifications.add((token: token, password: password));
    return onVerify?.call(token, password) ??
        const Success(VerifyEmailConfirmed('verified'));
  }

  @override
  Future<Result<String>> resendVerification() async {
    resends++;
    return onResend?.call() ?? const Success('sent again');
  }
}

/// Holds every answer until the test releases it.
class _HeldRecovery implements AccountRecoveryRepository {
  final request = Completer<Result<String>>();
  final reset = Completer<Result<String>>();
  final verify = Completer<Result<VerifyEmailAnswer>>();
  final resend = Completer<Result<String>>();

  @override
  Future<Result<String>> requestPasswordRecovery(String email) =>
      request.future;

  @override
  Future<Result<String>> resetPassword({
    required String token,
    required String newPassword,
  }) => reset.future;

  @override
  Future<Result<VerifyEmailAnswer>> verifyEmail(
    String token, {
    String? password,
  }) => verify.future;

  @override
  Future<Result<String>> resendVerification() => resend.future;
}

/// Asks for the password at once, then holds the confirmation until released.
class _HeldConfirmation extends FakeRecovery {
  final held = Completer<Result<VerifyEmailAnswer>>();

  @override
  Future<Result<VerifyEmailAnswer>> verifyEmail(
    String token, {
    String? password,
  }) {
    if (password == null) {
      return super.verifyEmail(token, password: password);
    }
    verifications.add((token: token, password: password));
    return held.future;
  }
}

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

HttpAccountRecoveryRepository _repository(_Adapter adapter) =>
    HttpAccountRecoveryRepository(
      AuthClient(
        Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
          ..httpClientAdapter = adapter,
      ),
    );

ProviderContainer containerWith(FakeRecovery repository) {
  final container = ProviderContainer(
    overrides: [
      accountRecoveryRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pump(
  WidgetTester tester,
  FakeRecovery repository,
  Widget screen,
) => tester.pumpWidget(
  ProviderScope(
    overrides: [
      accountRecoveryRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(home: screen),
  ),
);

void main() {
  group('requestPasswordRecovery', () {
    test(
      'Given a malformed address '
      'When it is submitted '
      'Then it is rejected and nothing reaches the API (UC-09 AF-01)',
      () async {
        final repository = FakeRecovery();
        final container = containerWith(repository);

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .requestPasswordRecovery('nonsense');

        expect(
          container.read(accountRecoveryControllerProvider),
          isA<RecoveryInvalid>(),
        );
        expect(repository.requested, isEmpty);
      },
    );

    test('Given a registered address and an unregistered one '
        'When each is submitted '
        'Then the confirmation is identical, so neither can be told apart '
        '(UC-09 AF-02)', () async {
      const identical = 'If that address belongs to an account, check it.';

      final states = <String>[];
      for (final email in ['real@example.com', 'nobody@example.com']) {
        final container = containerWith(
          FakeRecovery(onRequest: (_) => const Success(identical)),
        );

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .requestPasswordRecovery(email);

        final state = container.read(accountRecoveryControllerProvider);
        expect(state, isA<RecoveryDone>());
        states.add(state.message!);
      }

      // The whole of AF-02: the two answers are the same answer.
      expect(states.first, states.last);
    });

    test('Given an address with surrounding spaces '
        'When it is submitted '
        'Then the API receives it trimmed', () async {
      final repository = FakeRecovery();
      final container = containerWith(repository);

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .requestPasswordRecovery('  someone@example.com  ');

      expect(repository.requested, ['someone@example.com']);
    });
  });

  group('resetPassword', () {
    test(
      'Given a password and a confirmation that differ '
      'When they are submitted '
      'Then it is rejected and nothing reaches the API (UC-09 AF-04)',
      () async {
        final repository = FakeRecovery();
        final container = containerWith(repository);

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .resetPassword(
              token: 'tok',
              newPassword: 'one',
              confirmation: 'another',
            );

        final state = container.read(accountRecoveryControllerProvider);
        expect(state, isA<RecoveryInvalid>());
        expect(state.message, 'The two passwords do not match.');
        expect(repository.resets, isEmpty);
      },
    );

    test('Given a matching password '
        'When the API accepts it '
        "Then the API's confirmation is shown (UC-09 main flow)", () async {
      final container = containerWith(
        FakeRecovery(onReset: (_, _) => const Success('Password updated.')),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .resetPassword(
            token: 'tok',
            newPassword: 'secret',
            confirmation: 'secret',
          );

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryDone>());
      expect(state.message, 'Password updated.');
    });

    test('Given an expired or invalid token '
        'When the API refuses '
        'Then a new one can be requested (UC-09 AF-03)', () async {
      for (final kind in [FailureKind.notFound, FailureKind.unauthenticated]) {
        final container = containerWith(
          FakeRecovery(
            onReset: (_, _) =>
                Failure(message: 'That reset link has expired.', kind: kind),
          ),
        );

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .resetPassword(
              token: 'stale',
              newPassword: 'secret',
              confirmation: 'secret',
            );

        final state = container.read(accountRecoveryControllerProvider);
        expect(state, isA<RecoveryRefused>());
        expect((state as RecoveryRefused).canRequestAnother, isTrue);
      }
    });

    test(
      'Given the API refuses the password itself '
      'When it answers '
      'Then its rule is shown and no new link is offered (UC-09 AF-05)',
      () async {
        final container = containerWith(
          FakeRecovery(
            onReset: (_, _) => const Failure(
              message: 'A password must be at least twelve characters.',
              kind: FailureKind.invalidInput,
            ),
          ),
        );

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .resetPassword(
              token: 'tok',
              newPassword: 'short',
              confirmation: 'short',
            );

        final state = container.read(accountRecoveryControllerProvider);
        expect(state, isA<RecoveryRefused>());
        expect(state.message, 'A password must be at least twelve characters.');
        // Another link would send the user round a loop that changes nothing.
        expect((state as RecoveryRefused).canRequestAnother, isFalse);
      },
    );

    test('Given a reset link with no token '
        'When the screen submits '
        'Then it says the link is incomplete and offers a new one', () async {
      final repository = FakeRecovery();
      final container = containerWith(repository);

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .resetPassword(token: '  ', newPassword: 'x', confirmation: 'x');

      expect(
        container.read(accountRecoveryControllerProvider),
        isA<RecoveryRefused>(),
      );
      expect(repository.resets, isEmpty);
    });
  });

  group('verifyEmail and resendVerification', () {
    test('Given a verification token '
        'When it is submitted '
        "Then the API's outcome is reported (UC-09 step 7)", () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) =>
              const Success(VerifyEmailConfirmed('Address verified.')),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      expect(
        container.read(accountRecoveryControllerProvider).message,
        'Address verified.',
      );
    });

    test('Given a dead verification token '
        'When the API refuses '
        'Then a new message can be requested (UC-09 AF-03)', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) => const Failure(
            message: 'That verification link has expired.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('stale');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryRefused>());
      expect((state as RecoveryRefused).canRequestAnother, isTrue);
    });

    test('Given a verification message requested again too soon '
        'When the API rate-limits it '
        'Then it is presented as an answer rather than a failure '
        '(UC-09 AF-06)', () async {
      for (final kind in [FailureKind.conflict, FailureKind.forbidden]) {
        final container = containerWith(
          FakeRecovery(
            onResend: () => Failure(
              message: 'Wait a minute before asking again.',
              kind: kind,
            ),
          ),
        );

        await container
            .read(accountRecoveryControllerProvider.notifier)
            .resendVerification();

        final state = container.read(accountRecoveryControllerProvider);
        expect(
          state,
          isA<RecoveryRateLimited>(),
          reason: '$kind should read as "not yet", not as an error',
        );
        expect(state.message, 'Wait a minute before asking again.');
      }
    });
  });

  group('a provider disposed while an answer is pending', () {
    final operations =
        <
          String,
          (
            Future<void> Function(AccountRecoveryController),
            void Function(_HeldRecovery),
          )
        >{
          'requestPasswordRecovery': (
            (c) => c.requestPasswordRecovery('a@b.co'),
            (r) => r.request.complete(const Success('sent')),
          ),
          'resetPassword': (
            (c) => c.resetPassword(
              token: 'tok',
              newPassword: 'x',
              confirmation: 'x',
            ),
            (r) => r.reset.complete(const Success('reset')),
          ),
          'verifyEmail': (
            (c) => c.verifyEmail('tok'),
            (r) => r.verify.complete(
              const Success(VerifyEmailConfirmed('verified')),
            ),
          ),
          'confirmRegistration': (
            (c) => c.confirmRegistration(token: 'tok', password: 'pw'),
            (r) => r.verify.complete(
              const Success(VerifyEmailConfirmed('verified')),
            ),
          ),
          'resendVerification': (
            (c) => c.resendVerification(),
            (r) => r.resend.complete(const Success('sent')),
          ),
        };

    for (final MapEntry(:key, :value) in operations.entries) {
      test('Given $key is pending '
          'When the provider is disposed and the answer arrives '
          'Then nothing is written to it and nothing throws', () async {
        final (start, release) = value;
        final repository = _HeldRecovery();
        final container = ProviderContainer(
          overrides: [
            accountRecoveryRepositoryProvider.overrideWithValue(repository),
          ],
        );
        final pending = start(
          container.read(accountRecoveryControllerProvider.notifier),
        );
        await Future<void>.delayed(Duration.zero);

        container.dispose();
        release(repository);

        await expectLater(pending, completes);
      });
    }
  });

  group('verifyEmail for a sign-up link', () {
    const prompt =
        'Enter the password you chose when you signed up to finish creating '
        'your account.';
    const wrong =
        'That password does not match the one chosen when signing up.';

    Result<VerifyEmailAnswer> needsPassword(String token, String? password) =>
        password == null
        ? const Success(VerifyEmailPasswordNeeded(prompt))
        : const Success(VerifyEmailConfirmed('Your account is ready.'));

    test('Given a plain verification token '
        'When the API confirms '
        'Then the screen is done', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) =>
              const Success(VerifyEmailConfirmed('Address verified.')),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      expect(
        container.read(accountRecoveryControllerProvider),
        isA<RecoveryDone>(),
      );
    });

    test('Given a sign-up token sent without a password '
        'When the API asks for it '
        'Then the password is asked for, with no error yet', () async {
      final container = containerWith(FakeRecovery(onVerify: needsPassword));

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryNeedsPassword>());
      expect((state as RecoveryNeedsPassword).message, prompt);
      expect(state.error, isNull);
    });

    test('Given the password is asked for '
        'When a wrong one is confirmed '
        'Then it was sent, and the prompt stays with the API reason as the '
        'error', () async {
      final repository = FakeRecovery(
        onVerify: (_, password) => password == null
            ? const Success(VerifyEmailPasswordNeeded(prompt))
            : const Success(VerifyEmailPasswordWrong(wrong)),
      );
      final container = containerWith(repository);
      final controller = container.read(
        accountRecoveryControllerProvider.notifier,
      );

      await controller.verifyEmail('tok');
      await controller.confirmRegistration(token: 'tok', password: ' nope ');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryNeedsPassword>());
      expect((state as RecoveryNeedsPassword).message, prompt);
      expect(state.error, wrong);
      // Not trimmed: a password is exactly what was typed.
      expect(repository.verifications.last, (token: 'tok', password: ' nope '));
    });

    test('Given a wrong password is on screen '
        'When the user edits the field '
        'Then the error clears and the prompt stays', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, password) => password == null
              ? const Success(VerifyEmailPasswordNeeded(prompt))
              : const Success(VerifyEmailPasswordWrong(wrong)),
        ),
      );
      final controller = container.read(
        accountRecoveryControllerProvider.notifier,
      );
      await controller.verifyEmail('tok');
      await controller.confirmRegistration(token: 'tok', password: 'nope');

      controller.clearConfirmationError();

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryNeedsPassword>());
      expect((state as RecoveryNeedsPassword).message, prompt);
      expect(state.error, isNull);
    });

    test('Given the screen is not asking for a password '
        'When the user edits a field '
        'Then the state is left alone', () async {
      final container = containerWith(FakeRecovery());
      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      container
          .read(accountRecoveryControllerProvider.notifier)
          .clearConfirmationError();

      expect(
        container.read(accountRecoveryControllerProvider),
        isA<RecoveryDone>(),
      );
    });

    test('Given the password is asked for '
        'When the right one is confirmed '
        'Then the account is done', () async {
      final container = containerWith(FakeRecovery(onVerify: needsPassword));
      final controller = container.read(
        accountRecoveryControllerProvider.notifier,
      );

      await controller.verifyEmail('tok');
      await controller.confirmRegistration(token: 'tok', password: 'right');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryDone>());
      expect(state.message, 'Your account is ready.');
    });

    test('Given the password is asked for '
        'When an empty one is confirmed '
        'Then the form says so and nothing is sent', () async {
      final repository = FakeRecovery(onVerify: needsPassword);
      final container = containerWith(repository);
      final controller = container.read(
        accountRecoveryControllerProvider.notifier,
      );

      await controller.verifyEmail('tok');
      await controller.confirmRegistration(token: 'tok', password: '');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryNeedsPassword>());
      expect((state as RecoveryNeedsPassword).message, prompt);
      expect(state.error, 'Enter your password.');
      expect(repository.verifications, hasLength(1));
    });

    test('Given a link the API rejects as bad '
        'When it answers 400 '
        'Then the reason carries the sign-up hint', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) => const Failure(
            message: 'That link is no longer valid.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryRefused>());
      expect(
        state.message,
        'That link is no longer valid. If this link came from signing up, '
        'sign up again — or sign in if you already finished.',
      );
      expect((state as RecoveryRefused).canRequestAnother, isTrue);
    });

    for (final kind in [FailureKind.unreachable, FailureKind.serverError]) {
      test(
        'Given the password is asked for '
        'When confirming fails with $kind '
        'Then the form stays with the reason, so the user can retry',
        () async {
          var attempts = 0;
          final repository = FakeRecovery(
            onVerify: (_, password) {
              if (password == null)
                return const Success(VerifyEmailPasswordNeeded(prompt));
              attempts++;
              return attempts == 1
                  ? Failure(message: 'Try again in a moment.', kind: kind)
                  : const Success(
                      VerifyEmailConfirmed('Your account is ready.'),
                    );
            },
          );
          final container = containerWith(repository);
          final controller = container.read(
            accountRecoveryControllerProvider.notifier,
          );

          await controller.verifyEmail('tok');
          await controller.confirmRegistration(token: 'tok', password: 'right');

          final state = container.read(accountRecoveryControllerProvider);
          expect(state, isA<RecoveryNeedsPassword>());
          expect((state as RecoveryNeedsPassword).message, prompt);
          expect(state.error, 'Try again in a moment.');

          await controller.confirmRegistration(token: 'tok', password: 'right');

          expect(
            container.read(accountRecoveryControllerProvider),
            isA<RecoveryDone>(),
          );
        },
      );
    }

    test('Given the initial verification cannot reach the instance '
        'When the failure is shown '
        'Then it is the message alone, without the sign-up hint', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) => const Failure(
            message: 'Could not reach the server.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      expect(
        container.read(accountRecoveryControllerProvider).message,
        'Could not reach the server.',
      );
    });

    test('Given a failure that is neither a 400 nor transient '
        'When it is shown '
        'Then it carries no sign-up hint', () async {
      final container = containerWith(
        FakeRecovery(
          onVerify: (_, _) => const Failure(
            message: 'Not allowed.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .verifyEmail('tok');

      expect(
        container.read(accountRecoveryControllerProvider).message,
        'Not allowed.',
      );
    });

    test('Given an empty token '
        'When the registration is confirmed '
        'Then it is refused like verifyEmail and nothing is sent', () async {
      final repository = FakeRecovery(onVerify: needsPassword);
      final container = containerWith(repository);

      await container
          .read(accountRecoveryControllerProvider.notifier)
          .confirmRegistration(token: '  ', password: 'right');

      final state = container.read(accountRecoveryControllerProvider);
      expect(state, isA<RecoveryRefused>());
      expect(
        state.message,
        'This verification link is incomplete. Request a new one.',
      );
      expect((state as RecoveryRefused).canRequestAnother, isTrue);
      expect(repository.verifications, isEmpty);
    });
  });

  group('HttpAccountRecoveryRepository.verifyEmail', () {
    Map<String, Object?> envelope({
      required bool success,
      List<String> messages = const [],
      List<String> errors = const [],
    }) => {
      'success': success,
      'data': <String, Object?>{},
      'messages': messages,
      'errors': errors,
    };

    test('Given the API accepts '
        'When verifying a plain token '
        'Then it is confirmed with the API message and no password is '
        'sent', () async {
      final adapter = _Adapter(
        200,
        jsonEncode(envelope(success: true, messages: ['Verified.'])),
      );

      final result = await _repository(adapter).verifyEmail('tok');

      expect(result, isA<Success<VerifyEmailAnswer>>());
      final answer = (result as Success<VerifyEmailAnswer>).value;
      expect(answer, isA<VerifyEmailConfirmed>());
      expect(answer.message, 'Verified.');
      expect(adapter.request!.path, endsWith('/api/auth/verify-email'));
      final sent = jsonDecode(jsonEncode(adapter.request!.data)) as Map;
      expect(sent['token'], 'tok');
      // The generated command writes an unset password as an explicit null,
      // which the API reads the same as an absent one.
      expect(sent['password'], isNull);
    });

    test('Given the API accepts '
        'When a password is given '
        'Then the request carries it', () async {
      final adapter = _Adapter(
        200,
        jsonEncode(envelope(success: true, messages: ['Created.'])),
      );

      await _repository(adapter).verifyEmail('tok', password: 'secret');

      final sent = jsonDecode(jsonEncode(adapter.request!.data)) as Map;
      expect(sent['token'], 'tok');
      expect(sent['password'], 'secret');
    });

    test('Given a sign-up token without a password '
        'When the API answers 422 '
        'Then the password is needed, as an answer', () async {
      final adapter = _Adapter(
        422,
        jsonEncode(envelope(success: false, errors: ['Enter it.'])),
      );

      final result = await _repository(adapter).verifyEmail('tok');

      expect(result, isA<Success<VerifyEmailAnswer>>());
      final answer = (result as Success<VerifyEmailAnswer>).value;
      expect(answer, isA<VerifyEmailPasswordNeeded>());
      expect(answer.message, 'Enter it.');
    });

    test('Given a sign-up token with the wrong password '
        'When the API answers 401 '
        'Then the password is wrong, as an answer', () async {
      final adapter = _Adapter(
        401,
        jsonEncode(envelope(success: false, errors: ['Does not match.'])),
      );

      final result = await _repository(adapter)
          .verifyEmail('tok', password: 'nope');

      expect(result, isA<Success<VerifyEmailAnswer>>());
      final answer = (result as Success<VerifyEmailAnswer>).value;
      expect(answer, isA<VerifyEmailPasswordWrong>());
      expect(answer.message, 'Does not match.');
    });

    test('Given a bad, expired or used link '
        'When the API answers 400 '
        'Then it is a failure', () async {
      final adapter = _Adapter(
        400,
        jsonEncode(envelope(success: false, errors: ['Bad link.'])),
      );

      final result = await _repository(adapter).verifyEmail('tok');

      expect(
        result,
        const Failure<VerifyEmailAnswer>(
          message: 'Bad link.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('PasswordRecoveryScreen', () {
    testWidgets('Given an address is submitted '
        'When the API confirms '
        'Then its wording is shown unchanged (UC-09 AF-02)', (tester) async {
      const confirmation = 'If that address belongs to an account, check it.';
      await pump(
        tester,
        FakeRecovery(onRequest: (_) => const Success(confirmation)),
        const PasswordRecoveryScreen(),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recovery.email')),
        'someone@example.com',
      );
      await tester.tap(find.byKey(const Key('recovery.request')));
      await tester.pumpAndSettle();

      expect(find.text(confirmation), findsOneWidget);
    });
  });

  group('PasswordResetScreen', () {
    testWidgets('Given the two passwords differ '
        'When reset is attempted '
        'Then the form says so (UC-09 AF-04)', (tester) async {
      final repository = FakeRecovery();
      await pump(tester, repository, const PasswordResetScreen(token: 'tok'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('reset.password')), 'one');
      await tester.enterText(
        find.byKey(const Key('reset.confirmation')),
        'another',
      );
      await tester.tap(find.byKey(const Key('reset.submit')));
      await tester.pumpAndSettle();

      expect(find.text('The two passwords do not match.'), findsOneWidget);
      expect(repository.resets, isEmpty);
    });

    testWidgets('Given an expired token '
        'When the API refuses '
        'Then a new link can be requested (UC-09 AF-03)', (tester) async {
      await pump(
        tester,
        FakeRecovery(
          onReset: (_, _) => const Failure(
            message: 'That reset link has expired.',
            kind: FailureKind.notFound,
          ),
        ),
        const PasswordResetScreen(token: 'stale'),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('reset.password')), 'secret');
      await tester.enterText(
        find.byKey(const Key('reset.confirmation')),
        'secret',
      );
      await tester.tap(find.byKey(const Key('reset.submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reset.requestAnother')), findsOneWidget);
    });
  });

  group('VerifyEmailScreen', () {
    testWidgets('Given a link carrying a token '
        'When the screen opens '
        'Then it verifies without the user doing anything (UC-09 step 7)', (
      tester,
    ) async {
      final repository = FakeRecovery(
        onVerify: (_, _) =>
            const Success(VerifyEmailConfirmed('Address verified.')),
      );
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      expect(repository.verified, ['tok']);
      expect(find.text('Address verified.'), findsOneWidget);
    });

    testWidgets('Given a sign-up link '
        'When the API asks for the password '
        'Then the form is shown and nothing is submitted a second time by '
        'itself', (tester) async {
      final repository = FakeRecovery(
        onVerify: (_, _) =>
            const Success(VerifyEmailPasswordNeeded('Enter your password.')),
      );
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('verify.passwordNeeded')), findsOneWidget);
      expect(find.byKey(const Key('verify.confirm')), findsOneWidget);
      final field = tester.widget<TextField>(
        find.byKey(const Key('verify.password')),
      );
      expect(field.obscureText, isTrue);
      expect(find.byKey(const Key('verify.resend')), findsNothing);
      expect(repository.verifications, hasLength(1));
      expect(repository.verifications.single.password, isNull);
    });

    testWidgets('Given the password form is shown '
        'When the right password is confirmed '
        'Then {token, password} is submitted once and the account is '
        'done', (tester) async {
      final repository = FakeRecovery(
        onVerify: (_, password) => password == null
            ? const Success(VerifyEmailPasswordNeeded('Enter your password.'))
            : const Success(VerifyEmailConfirmed('Your account is ready.')),
      );
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('verify.password')), 'right');
      await tester.tap(find.byKey(const Key('verify.confirm')));
      await tester.pumpAndSettle();

      expect(repository.verifications, hasLength(2));
      expect(repository.verifications.last, (token: 'tok', password: 'right'));
      expect(find.byKey(const Key('verify.done')), findsOneWidget);
      expect(find.text('Your account is ready.'), findsOneWidget);
    });

    testWidgets('Given the password form is shown '
        'When a wrong password is confirmed '
        "Then the API's message is the field's error and the form stays", (
      tester,
    ) async {
      const wrong = 'That password does not match.';
      final repository = FakeRecovery(
        onVerify: (_, password) => password == null
            ? const Success(VerifyEmailPasswordNeeded('Enter your password.'))
            : const Success(VerifyEmailPasswordWrong(wrong)),
      );
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('verify.password')), 'nope');
      await tester.tap(find.byKey(const Key('verify.confirm')));
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(
        find.byKey(const Key('verify.password')),
      );
      expect(field.decoration!.errorText, wrong);
      expect(find.byKey(const Key('verify.confirm')), findsOneWidget);
      expect(find.byKey(const Key('verify.passwordNeeded')), findsOneWidget);
      expect(find.byKey(const Key('verify.resend')), findsNothing);
    });

    testWidgets('Given the password is being confirmed '
        'When the answer is pending '
        'Then the form stays, disabled, rather than vanishing', (tester) async {
      final repository = _HeldConfirmation();
      repository.onVerify = (_, _) =>
          const Success(VerifyEmailPasswordNeeded('Enter your password.'));
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('verify.password')), 'right');
      await tester.tap(find.byKey(const Key('verify.confirm')));
      await tester.pump();

      expect(find.byKey(const Key('verify.passwordNeeded')), findsOneWidget);
      final field = tester.widget<TextField>(
        find.byKey(const Key('verify.password')),
      );
      expect(field.enabled, isFalse);
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('verify.confirm')),
      );
      expect(button.onPressed, isNull);

      repository.held.complete(
        const Success(VerifyEmailConfirmed('Your account is ready.')),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('Given the account was confirmed '
        'When the screen is done '
        'Then "Sign in" is offered, calls back, and no resend is', (
      tester,
    ) async {
      var signedIn = 0;
      await pump(
        tester,
        FakeRecovery(
          onVerify: (_, _) =>
              const Success(VerifyEmailConfirmed('Address verified.')),
        ),
        VerifyEmailScreen(token: 'tok', onSignIn: () => signedIn++),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('verify.signIn')), findsOneWidget);
      expect(find.byKey(const Key('verify.signUp')), findsNothing);
      expect(find.byKey(const Key('verify.resend')), findsNothing);

      await tester.tap(find.byKey(const Key('verify.signIn')));

      expect(signedIn, 1);
    });

    testWidgets('Given a link the API refuses '
        'When the screen shows why '
        'Then "Sign in" and "Sign up again" are offered, and no resend', (
      tester,
    ) async {
      var signedIn = 0;
      var signedUp = 0;
      await pump(
        tester,
        FakeRecovery(
          onVerify: (_, _) => const Failure(
            message: 'That link is no longer valid.',
            kind: FailureKind.invalidInput,
          ),
        ),
        VerifyEmailScreen(
          token: 'tok',
          onSignIn: () => signedIn++,
          onSignUp: () => signedUp++,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('verify.resend')), findsNothing);
      await tester.tap(find.byKey(const Key('verify.signIn')));
      await tester.tap(find.byKey(const Key('verify.signUp')));

      expect(signedIn, 1);
      expect(signedUp, 1);
    });

    group('the password field', () {
      const wrong = 'That password does not match.';

      FakeRecovery asking() => FakeRecovery(
        onVerify: (_, password) => password == null
            ? const Success(VerifyEmailPasswordNeeded('Enter your password.'))
            : const Success(VerifyEmailPasswordWrong(wrong)),
      );

      FocusNode focusOfPassword(WidgetTester tester) => tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(const Key('verify.password')),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode;

      testWidgets('Given a wrong password was confirmed '
          'When the form comes back '
          'Then the field has focus with its text selected', (tester) async {
        await pump(tester, asking(), const VerifyEmailScreen(token: 'tok'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('verify.password')),
          'nope',
        );
        // Moving away is what a tap on the button does.
        focusOfPassword(tester).unfocus();
        await tester.pump();
        expect(focusOfPassword(tester).hasFocus, isFalse);

        await tester.tap(find.byKey(const Key('verify.confirm')));
        await tester.pumpAndSettle();

        expect(focusOfPassword(tester).hasFocus, isTrue);
        final field = tester.widget<TextField>(
          find.byKey(const Key('verify.password')),
        );
        expect(
          field.controller!.selection,
          const TextSelection(baseOffset: 0, extentOffset: 4),
        );
      });

      testWidgets('Given a wrong password is shown '
          'When the user edits the field '
          'Then its error clears', (tester) async {
        await pump(tester, asking(), const VerifyEmailScreen(token: 'tok'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('verify.password')),
          'nope',
        );
        await tester.tap(find.byKey(const Key('verify.confirm')));
        await tester.pumpAndSettle();
        TextField field() =>
            tester.widget<TextField>(find.byKey(const Key('verify.password')));
        expect(field().decoration!.errorText, wrong);

        await tester.enterText(
          find.byKey(const Key('verify.password')),
          'nope2',
        );
        await tester.pump();

        expect(field().decoration!.errorText, isNull);
        expect(find.byKey(const Key('verify.passwordNeeded')), findsOneWidget);
      });

      testWidgets('Given the password field '
          'When the reveal toggle is tapped '
          'Then the text is shown, and hidden again on a second tap', (
        tester,
      ) async {
        await pump(tester, asking(), const VerifyEmailScreen(token: 'tok'));
        await tester.pumpAndSettle();
        bool obscured() => tester
            .widget<TextField>(find.byKey(const Key('verify.password')))
            .obscureText;
        expect(obscured(), isTrue);

        await tester.tap(find.byKey(const Key('verify.reveal')));
        await tester.pump();
        expect(obscured(), isFalse);

        await tester.tap(find.byKey(const Key('verify.reveal')));
        await tester.pump();
        expect(obscured(), isTrue);
      });

      testWidgets('Given the account was created '
          'When the form is shown again '
          'Then the password is no longer in the field', (tester) async {
        final repository = FakeRecovery(
          onVerify: (_, password) => password == null
              ? const Success(VerifyEmailPasswordNeeded('Enter your password.'))
              : const Success(VerifyEmailConfirmed('Your account is ready.')),
        );
        await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('verify.password')),
          'right',
        );
        await tester.tap(find.byKey(const Key('verify.confirm')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('verify.done')), findsOneWidget);

        // The field is gone while done; asking again brings the same one back.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(VerifyEmailScreen)),
        );
        await container
            .read(accountRecoveryControllerProvider.notifier)
            .verifyEmail('tok');
        await tester.pumpAndSettle();

        final field = tester.widget<TextField>(
          find.byKey(const Key('verify.password')),
        );
        expect(field.controller!.text, isEmpty);
      });
    });

    testWidgets('Given the screen is reached with no token '
        'When it opens '
        'Then nothing is verified and only a resend is offered', (
      tester,
    ) async {
      final repository = FakeRecovery();
      await pump(tester, repository, const VerifyEmailScreen());
      await tester.pumpAndSettle();

      expect(repository.verified, isEmpty);
      expect(find.byKey(const Key('verify.resend')), findsOneWidget);
    });

    testWidgets('Given a resend is rate-limited '
        'When it is reported '
        'Then it does not read as an error (UC-09 AF-06)', (tester) async {
      await pump(
        tester,
        FakeRecovery(
          onResend: () => const Failure(
            message: 'Wait a minute before asking again.',
            kind: FailureKind.conflict,
          ),
        ),
        const VerifyEmailScreen(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('verify.resend')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('verify.rateLimited')), findsOneWidget);
      expect(find.text('Wait a minute before asking again.'), findsOneWidget);
    });
  });
}
