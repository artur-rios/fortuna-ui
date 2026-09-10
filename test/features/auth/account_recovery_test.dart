import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/account_recovery_repository.dart';
import 'package:fortuna_ui/features/auth/state/account_recovery_controller.dart';
import 'package:fortuna_ui/features/auth/ui/password_recovery_screen.dart';

class FakeRecovery implements AccountRecoveryRepository {
  FakeRecovery({this.onRequest, this.onReset, this.onVerify, this.onResend});

  Result<String> Function(String email)? onRequest;
  Result<String> Function(String token, String newPassword)? onReset;
  Result<String> Function(String token)? onVerify;
  Result<String> Function()? onResend;

  final List<String> requested = [];
  final List<({String token, String password})> resets = [];
  final List<String> verified = [];
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
  Future<Result<String>> verifyEmail(String token) async {
    verified.add(token);
    return onVerify?.call(token) ?? const Success('verified');
  }

  @override
  Future<Result<String>> resendVerification() async {
    resends++;
    return onResend?.call() ?? const Success('sent again');
  }
}

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
        FakeRecovery(onVerify: (_) => const Success('Address verified.')),
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
          onVerify: (_) => const Failure(
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
        onVerify: (_) => const Success('Address verified.'),
      );
      await pump(tester, repository, const VerifyEmailScreen(token: 'tok'));
      await tester.pumpAndSettle();

      expect(repository.verified, ['tok']);
      expect(find.text('Address verified.'), findsOneWidget);
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
