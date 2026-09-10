import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/two_factor_repository.dart';
import 'package:fortuna_ui/features/auth/state/two_factor_controller.dart';
import 'package:fortuna_ui/features/auth/ui/two_factor_screen.dart';

const _otpUri =
    'otpauth://totp/Fortuna:someone@example.com'
    '?secret=JBSWY3DPEHPK3PXP&issuer=Fortuna';

class FakeTwoFactor implements TwoFactorRepository {
  FakeTwoFactor({
    this.onStatus,
    this.onEnable,
    this.onConfirm,
    this.onDisable,
    this.onRegenerate,
  });

  Result<TwoFactorStatus> Function()? onStatus;
  Result<TwoFactorSetup> Function(List<TwoFactorMethod>)? onEnable;
  Result<List<String>> Function(String? app, String? email)? onConfirm;
  Result<void> Function(String password, String? code)? onDisable;
  Result<List<String>> Function()? onRegenerate;

  final List<List<TwoFactorMethod>> enabled = [];
  final List<({String? app, String? email})> confirmations = [];
  int disables = 0;
  int regenerations = 0;

  @override
  Future<Result<TwoFactorStatus>> status() async =>
      onStatus?.call() ??
      const Success(
        TwoFactorStatus(
          isActive: false,
          appEnabled: false,
          emailEnabled: false,
          remainingRecoveryCodes: 0,
        ),
      );

  @override
  Future<Result<TwoFactorSetup>> enable(List<TwoFactorMethod> methods) async {
    enabled.add(methods);
    return onEnable?.call(methods) ??
        const Success(
          TwoFactorSetup(otpAuthUri: _otpUri, emailCodeSent: false),
        );
  }

  @override
  Future<Result<List<String>>> confirm({
    String? appCode,
    String? emailCode,
  }) async {
    confirmations.add((app: appCode, email: emailCode));
    return onConfirm?.call(appCode, emailCode) ??
        const Success(['CODE-1', 'CODE-2']);
  }

  @override
  Future<Result<void>> disable({
    required String password,
    String? code,
    String? recoveryCode,
  }) async {
    disables++;
    return onDisable?.call(password, code) ?? const Success(null);
  }

  @override
  Future<Result<List<String>>> regenerateRecoveryCodes({
    String? code,
    String? recoveryCode,
  }) async {
    regenerations++;
    return onRegenerate?.call() ?? const Success(['NEW-1']);
  }
}

Result<TwoFactorStatus> active({
  bool app = true,
  bool email = false,
  int remaining = 5,
}) => Success(
  TwoFactorStatus(
    isActive: true,
    appEnabled: app,
    emailEnabled: email,
    remainingRecoveryCodes: remaining,
  ),
);

ProviderContainer containerWith(FakeTwoFactor repository) {
  final container = ProviderContainer(
    overrides: [twoFactorRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpScreen(WidgetTester tester, FakeTwoFactor repository) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [twoFactorRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: TwoFactorScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('TwoFactorSetup.sharedSecret', () {
    test('Given an otpauth URI '
        'When the secret is read '
        'Then it is the one the URI carries (UC-10 step 3, FR-SE-13)', () {
      const setup = TwoFactorSetup(otpAuthUri: _otpUri, emailCodeSent: false);

      expect(setup.sharedSecret, 'JBSWY3DPEHPK3PXP');
    });

    test('Given a setup with no authenticator '
        'When the secret is read '
        'Then there is none, rather than an empty string', () {
      const setup = TwoFactorSetup(otpAuthUri: null, emailCodeSent: true);

      expect(setup.sharedSecret, isNull);
    });

    test('Given a URI carrying no secret '
        'When it is read '
        'Then nothing is offered to type', () {
      const setup = TwoFactorSetup(
        otpAuthUri: 'otpauth://totp/Fortuna',
        emailCodeSent: false,
      );

      expect(setup.sharedSecret, isNull);
    });
  });

  group('TwoFactorController', () {
    test(
      'Given an account with two-factor on '
      'When the screen loads '
      'Then its methods and remaining codes are reported (UC-10 step 1)',
      () async {
        final container = containerWith(
          FakeTwoFactor(onStatus: () => active(app: true, email: true)),
        );

        await container.read(twoFactorControllerProvider.notifier).load();

        final state = container.read(twoFactorControllerProvider);
        expect(state, isA<TwoFactorIdle>());
        expect((state as TwoFactorIdle).status.methods, [
          TwoFactorMethod.app,
          TwoFactorMethod.email,
        ]);
        expect(state.status.remainingRecoveryCodes, 5);
      },
    );

    test('Given an account that cannot hold a second factor '
        'When the status is read '
        "Then the API's reason is presented rather than a setup that would be "
        'refused (UC-10 AF-05)', () async {
      for (final kind in [FailureKind.forbidden, FailureKind.conflict]) {
        final container = containerWith(
          FakeTwoFactor(
            onStatus: () => Failure(
              message: 'Accounts that sign in with Google cannot use this.',
              kind: kind,
            ),
          ),
        );

        await container.read(twoFactorControllerProvider.notifier).load();

        final state = container.read(twoFactorControllerProvider);
        expect(state, isA<TwoFactorUnavailable>(), reason: '$kind');
        expect(
          state.message,
          'Accounts that sign in with Google cannot use this.',
        );
      }
    });

    test(
      'Given a chosen method '
      'When a setup is started '
      'Then the API is asked for exactly that method (UC-10 step 2)',
      () async {
        final repository = FakeTwoFactor();
        final container = containerWith(repository);

        await container.read(twoFactorControllerProvider.notifier).enable([
          TwoFactorMethod.app,
          TwoFactorMethod.email,
        ]);

        expect(repository.enabled.single, [
          TwoFactorMethod.app,
          TwoFactorMethod.email,
        ]);
        expect(
          container.read(twoFactorControllerProvider),
          isA<TwoFactorPending>(),
        );
      },
    );

    test('Given no method chosen '
        'When a setup is attempted '
        'Then it is refused before the API is asked', () async {
      final repository = FakeTwoFactor();
      final container = containerWith(repository);

      await container.read(twoFactorControllerProvider.notifier).enable([]);

      expect(repository.enabled, isEmpty);
      expect(
        container.read(twoFactorControllerProvider),
        isA<TwoFactorFailed>(),
      );
    });

    test('Given a pending setup '
        'When a valid code confirms it '
        'Then the recovery codes are presented once (UC-10 step 5)', () async {
      final container = containerWith(FakeTwoFactor());
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.enable([TwoFactorMethod.app]);
      await controller.confirm(appCode: '123456');

      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorCodesIssued>());
      expect((state as TwoFactorCodesIssued).codes, ['CODE-1', 'CODE-2']);
    });

    test(
      'Given a pending setup '
      'When the code is wrong '
      'Then the setup stays pending and may be tried again (UC-10 AF-01)',
      () async {
        final container = containerWith(
          FakeTwoFactor(
            onConfirm: (_, _) => const Failure(
              message: 'That code is not right.',
              kind: FailureKind.invalidInput,
            ),
          ),
        );
        final controller = container.read(twoFactorControllerProvider.notifier);

        await controller.enable([TwoFactorMethod.app]);
        await controller.confirm(appCode: '000000');

        final state = container.read(twoFactorControllerProvider);
        // Still pending — the setup was not cancelled by a bad guess.
        expect(state, isA<TwoFactorPending>());
        expect((state as TwoFactorPending).reason, 'That code is not right.');
        expect(state.setup.sharedSecret, 'JBSWY3DPEHPK3PXP');
      },
    );

    test('Given a pending setup '
        'When no code at all is entered '
        'Then it is refused without asking the API', () async {
      final repository = FakeTwoFactor();
      final container = containerWith(repository);
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.enable([TwoFactorMethod.app]);
      await controller.confirm(appCode: '  ', emailCode: '');

      expect(repository.confirmations, isEmpty);
      expect(
        container.read(twoFactorControllerProvider),
        isA<TwoFactorPending>(),
      );
    });

    test('Given the API reports a confirmation that did not enable anything '
        'When it answers '
        'Then it is treated as a failure rather than as success', () async {
      final container = containerWith(
        FakeTwoFactor(
          onConfirm: (_, _) => const Failure(
            message: 'The setup was not confirmed. Try the code again.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.enable([TwoFactorMethod.app]);
      await controller.confirm(appCode: '123456');

      expect(
        container.read(twoFactorControllerProvider),
        isA<TwoFactorPending>(),
      );
    });

    test(
      'Given a pending setup '
      'When it is abandoned '
      'Then two-factor is still off and nothing was recorded (UC-10 AF-02)',
      () async {
        final container = containerWith(FakeTwoFactor());
        final controller = container.read(twoFactorControllerProvider.notifier);

        await controller.enable([TwoFactorMethod.app]);
        expect(
          container.read(twoFactorControllerProvider),
          isA<TwoFactorPending>(),
        );

        await controller.abandonSetup();

        final state = container.read(twoFactorControllerProvider);
        expect(state, isA<TwoFactorIdle>());
        expect((state as TwoFactorIdle).status.isActive, isFalse);
      },
    );

    test(
      'Given a wrong password or a wrong second factor '
      'When disabling is attempted '
      "Then the API's message is presented, the same for both (UC-10 AF-03)",
      () async {
        const single = 'That password and code do not match.';
        final container = containerWith(
          FakeTwoFactor(
            onStatus: () => active(),
            onDisable: (_, _) => const Failure(
              message: single,
              kind: FailureKind.unauthenticated,
            ),
          ),
        );
        final controller = container.read(twoFactorControllerProvider.notifier);

        await controller.load();
        await controller.disable(password: 'wrong', code: '000000');

        final state = container.read(twoFactorControllerProvider);
        expect(state, isA<TwoFactorFailed>());
        expect(state.message, single);
        // The configuration is still shown, so the screen is not a dead end.
        expect((state as TwoFactorFailed).status, isNotNull);
      },
    );

    test('Given nothing is active '
        'When disabling is attempted '
        "Then the API's not-found answer is presented (UC-10 AF-04)", () async {
      final container = containerWith(
        FakeTwoFactor(
          onDisable: (_, _) => const Failure(
            message: 'Two-factor authentication is not set up.',
            kind: FailureKind.notFound,
          ),
        ),
      );
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.load();
      await controller.disable(password: 'p', code: 'c');

      expect(
        container.read(twoFactorControllerProvider).message,
        'Two-factor authentication is not set up.',
      );
    });

    test('Given an active setup '
        'When the codes are regenerated '
        'Then the new set is presented once (UC-10 step 6)', () async {
      final container = containerWith(
        FakeTwoFactor(
          onStatus: () => active(),
          onRegenerate: () => const Success(['NEW-1', 'NEW-2']),
        ),
      );
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.load();
      await controller.regenerateCodes(code: '123456');

      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorCodesIssued>());
      expect((state as TwoFactorCodesIssued).codes, ['NEW-1', 'NEW-2']);
    });
  });

  group('TwoFactorScreen', () {
    testWidgets('Given two-factor is off '
        'When the screen settles '
        'Then it says so and offers both methods (UC-10 step 1)', (
      tester,
    ) async {
      await pumpScreen(tester, FakeTwoFactor());

      expect(find.textContaining('is off'), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.method.app')), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.method.email')), findsOneWidget);
    });

    testWidgets('Given an authenticator setup '
        'When it is presented '
        'Then a scannable code AND the secret as text are both shown '
        '(UC-10 step 3, FR-SE-13)', (tester) async {
      await pumpScreen(tester, FakeTwoFactor());

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.qr')), findsOneWidget);
      // The text is not a fallback: it is the path for anyone who cannot scan.
      expect(find.text('JBSWY3DPEHPK3PXP'), findsOneWidget);
    });

    testWidgets('Given a setup with email only '
        'When it is presented '
        'Then there is no scannable code and no secret to type', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        FakeTwoFactor(
          onEnable: (_) => const Success(
            TwoFactorSetup(otpAuthUri: null, emailCodeSent: true),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.qr')), findsNothing);
      expect(find.byKey(const Key('twoFactor.emailCode')), findsOneWidget);
    });

    testWidgets('Given a wrong confirmation code '
        'When it is refused '
        'Then the setup is still on screen to try again (UC-10 AF-01)', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        FakeTwoFactor(
          onConfirm: (_, _) => const Failure(
            message: 'That code is not right.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('twoFactor.appCode')),
        '000000',
      );
      await tester.tap(find.byKey(const Key('twoFactor.confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.pendingReason')), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.qr')), findsOneWidget);
    });

    testWidgets('Given the recovery codes are showing '
        'When the user tries to leave '
        'Then they are warned the codes will not be shown again '
        '(UC-10 AF-06)', (tester) async {
      await pumpScreen(tester, FakeTwoFactor());

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('twoFactor.appCode')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('twoFactor.confirm')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.codes')), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.textContaining('will not be shown again'), findsOneWidget);
    });

    testWidgets('Given the account cannot hold a second factor '
        'When the screen settles '
        'Then no setup is offered at all (UC-10 AF-05)', (tester) async {
      await pumpScreen(
        tester,
        FakeTwoFactor(
          onStatus: () => const Failure(
            message: 'Accounts that sign in with Google cannot use this.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      expect(find.byKey(const Key('twoFactor.unavailable')), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.enable')), findsNothing);
    });
  });
}
