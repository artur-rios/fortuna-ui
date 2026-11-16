import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/two_factor_repository.dart';
import 'package:fortuna_ui/features/auth/state/two_factor_controller.dart';
import 'package:fortuna_ui/features/auth/ui/two_factor_screen.dart';
import 'package:material_ui/material_ui.dart';

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
  final List<({String password, String? code, String? recoveryCode})> disabled =
      [];
  final List<({String? code, String? recoveryCode})> regenerated = [];
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
    disabled.add((password: password, code: code, recoveryCode: recoveryCode));
    return onDisable?.call(password, code) ?? const Success(null);
  }

  @override
  Future<Result<List<String>>> regenerateRecoveryCodes({
    String? code,
    String? recoveryCode,
  }) async {
    regenerations++;
    regenerated.add((code: code, recoveryCode: recoveryCode));
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

/// Pushes the screen over a page, so leaving it can be observed.
Future<void> pumpPushedScreen(
  WidgetTester tester,
  FakeTwoFactor repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [twoFactorRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const TwoFactorScreen()),
            ),
            child: const Text('Open two-factor'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open two-factor'));
  await tester.pumpAndSettle();
}

/// From an off account through a confirmed setup to the recovery codes.
Future<void> reachRecoveryCodes(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('twoFactor.enable')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('twoFactor.appCode')), '123456');
  await tester.tap(find.byKey(const Key('twoFactor.confirm')));
  await tester.pumpAndSettle();
}

const _off = Success(
  TwoFactorStatus(
    isActive: false,
    appEnabled: false,
    emailEnabled: false,
    remainingRecoveryCodes: 0,
  ),
);

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
    test('Given each state '
        'When it is asked whether it is busy and what to say '
        'Then only an operation in flight is busy, and a pending reason is '
        'its message', () {
      const setup = TwoFactorSetup(otpAuthUri: _otpUri, emailCodeSent: false);

      expect(const TwoFactorWorking().isBusy, isTrue);
      expect(const TwoFactorLoading().isBusy, isFalse);
      expect(
        const TwoFactorPending(setup: setup, reason: 'Try again.').message,
        'Try again.',
      );
      expect(const TwoFactorPending(setup: setup).message, isNull);
      expect(const TwoFactorCodesIssued(['C']).message, isNull);
    });

    test('Given the instance cannot be reached '
        'When the status is read '
        'Then the reason is presented with no configuration to show', () async {
      final container = containerWith(
        FakeTwoFactor(
          onStatus: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await container.read(twoFactorControllerProvider.notifier).load();

      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorFailed>());
      expect(state.message, 'The instance could not be reached.');
      expect((state as TwoFactorFailed).status, isNull);
    });

    test(
      'Given a loaded status '
      'When the API refuses to start a setup '
      "Then its reason is presented with the account's status kept",
      () async {
        final container = containerWith(
          FakeTwoFactor(
            onEnable: (_) => const Failure(
              message: 'Email is not configured on this instance.',
              kind: FailureKind.conflict,
            ),
          ),
        );
        final controller = container.read(twoFactorControllerProvider.notifier);

        await controller.load();
        await controller.enable([TwoFactorMethod.email]);

        final state = container.read(twoFactorControllerProvider);
        expect(state, isA<TwoFactorFailed>());
        expect(state.message, 'Email is not configured on this instance.');
        expect((state as TwoFactorFailed).status?.isActive, isFalse);
      },
    );

    test('Given an idle account '
        'When a confirmation is attempted with no setup pending '
        'Then nothing is sent', () async {
      final repository = FakeTwoFactor();
      final container = containerWith(repository);
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.load();
      await controller.confirm(appCode: '123456');

      expect(repository.confirmations, isEmpty);
      expect(container.read(twoFactorControllerProvider), isA<TwoFactorIdle>());
    });

    test('Given two-factor is on '
        'When it is turned off with a recovery code '
        'Then the codes are sent trimmed and the status is re-read '
        '(UC-10 step 6)', () async {
      var on = true;
      final repository = FakeTwoFactor(
        onStatus: () => on ? active() : _off,
        onDisable: (_, _) {
          on = false;
          return const Success(null);
        },
      );
      final container = containerWith(repository);
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.load();
      await controller.disable(
        password: 'secret',
        code: ' 123456 ',
        recoveryCode: ' RC-1 ',
      );

      expect(repository.disabled.single, (
        password: 'secret',
        code: '123456',
        recoveryCode: 'RC-1',
      ));
      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorIdle>());
      expect((state as TwoFactorIdle).status.isActive, isFalse);
    });

    test('Given two-factor is on '
        'When replacing the codes is refused '
        "Then the API's reason is presented with the status kept", () async {
      final repository = FakeTwoFactor(
        onStatus: () => active(remaining: 2),
        onRegenerate: () => const Failure(
          message: 'That code is not right.',
          kind: FailureKind.unauthenticated,
        ),
      );
      final container = containerWith(repository);
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.load();
      await controller.regenerateCodes(recoveryCode: ' RC-9 ');

      expect(repository.regenerated.single, (code: null, recoveryCode: 'RC-9'));
      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorFailed>());
      expect(state.message, 'That code is not right.');
      expect((state as TwoFactorFailed).status?.remainingRecoveryCodes, 2);
    });

    test('Given the recovery codes are showing '
        'When they are confirmed as kept '
        'Then the configuration is re-read and shown', () async {
      final container = containerWith(FakeTwoFactor(onStatus: () => active()));
      final controller = container.read(twoFactorControllerProvider.notifier);

      await controller.regenerateCodes(code: '123456');
      expect(
        container.read(twoFactorControllerProvider),
        isA<TwoFactorCodesIssued>(),
      );

      await controller.confirmCodesKept();

      final state = container.read(twoFactorControllerProvider);
      expect(state, isA<TwoFactorIdle>());
      expect((state as TwoFactorIdle).status.isActive, isTrue);
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
    testWidgets('Given the leave warning over the recovery codes '
        'When the user goes back '
        'Then the codes are still on screen (UC-10 AF-06)', (tester) async {
      await pumpPushedScreen(tester, FakeTwoFactor());
      await reachRecoveryCodes(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('twoFactor.stay')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.codes')), findsOneWidget);
      expect(find.byType(TwoFactorScreen), findsOneWidget);
    });

    testWidgets('Given the leave warning over the recovery codes '
        'When the user leaves anyway '
        'Then the screen is closed (UC-10 AF-06)', (tester) async {
      await pumpPushedScreen(tester, FakeTwoFactor());
      await reachRecoveryCodes(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('twoFactor.leaveAnyway')));
      await tester.pumpAndSettle();

      expect(find.byType(TwoFactorScreen), findsNothing);
      expect(find.text('Open two-factor'), findsOneWidget);
    });

    testWidgets('Given the recovery codes are showing '
        'When the user ticks that they kept them and presses Done '
        'Then the configuration is shown again', (tester) async {
      await pumpScreen(tester, FakeTwoFactor());
      await reachRecoveryCodes(tester);

      final done = find.byKey(const Key('twoFactor.done'));
      expect(tester.widget<FilledButton>(done).onPressed, isNull);

      await tester.tap(find.byKey(const Key('twoFactor.kept')));
      await tester.pumpAndSettle();
      await tester.tap(done);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.codes')), findsNothing);
      expect(find.byKey(const Key('twoFactor.status')), findsOneWidget);
    });

    testWidgets('Given a pending setup '
        'When it is cancelled '
        'Then the configuration says two-factor is off (UC-10 AF-02)', (
      tester,
    ) async {
      await pumpScreen(tester, FakeTwoFactor());

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('twoFactor.abandon')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('twoFactor.qr')), findsNothing);
      expect(find.textContaining('is off'), findsOneWidget);
    });

    testWidgets('Given an authenticator setup '
        'When the secret is copied '
        'Then it goes to the clipboard and the user is told (FR-SE-13)', (
      tester,
    ) async {
      final copied = <String?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add(
              (call.arguments as Map<Object?, Object?>)['text'] as String?,
            );
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpScreen(tester, FakeTwoFactor());

      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('twoFactor.copySecret')));
      await tester.pumpAndSettle();

      expect(copied, ['JBSWY3DPEHPK3PXP']);
      expect(find.text('Copied to the clipboard.'), findsOneWidget);
    });

    testWidgets('Given two-factor is on with both methods '
        'When the screen settles '
        'Then the methods and the remaining codes are stated, and no setup is '
        'offered (UC-10 step 1)', (tester) async {
      await pumpScreen(
        tester,
        FakeTwoFactor(onStatus: () => active(email: true)),
      );

      expect(
        find.text(
          'Two-factor authentication is on, using authenticator app and '
          'email.',
        ),
        findsOneWidget,
      );
      expect(find.text('5 recovery codes left.'), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.enable')), findsNothing);
    });

    testWidgets('Given a single recovery code left '
        'When the screen settles '
        'Then it is counted in the singular', (tester) async {
      await pumpScreen(
        tester,
        FakeTwoFactor(onStatus: () => active(remaining: 1)),
      );

      expect(find.text('1 recovery code left.'), findsOneWidget);
    });

    testWidgets('Given two-factor is on '
        'When the user turns it off with their password and a code '
        'Then both are sent and the screen shows it off (UC-10 step 6)', (
      tester,
    ) async {
      var on = true;
      final repository = FakeTwoFactor(
        onStatus: () => on ? active() : _off,
        onDisable: (_, _) {
          on = false;
          return const Success(null);
        },
      );
      await pumpScreen(tester, repository);

      await tester.enterText(
        find.byKey(const Key('twoFactor.password')),
        'secret',
      );
      await tester.enterText(find.byKey(const Key('twoFactor.code')), '123456');
      await tester.tap(find.byKey(const Key('twoFactor.disable')));
      await tester.pumpAndSettle();

      expect(repository.disabled.single.password, 'secret');
      expect(repository.disabled.single.code, '123456');
      expect(find.textContaining('is off'), findsOneWidget);
    });

    testWidgets('Given two-factor is on '
        'When the user replaces their recovery codes '
        'Then the new set is shown once (UC-10 step 6)', (tester) async {
      final repository = FakeTwoFactor(
        onStatus: () => active(),
        onRegenerate: () => const Success(['NEW-1', 'NEW-2']),
      );
      await pumpScreen(tester, repository);

      await tester.enterText(find.byKey(const Key('twoFactor.code')), '123456');
      await tester.tap(find.byKey(const Key('twoFactor.regenerate')));
      await tester.pumpAndSettle();

      expect(repository.regenerated.single.code, '123456');
      expect(find.text('NEW-1\nNEW-2'), findsOneWidget);
    });

    testWidgets('Given turning two-factor off is refused '
        'When the API answers '
        'Then its reason is shown above the configuration, which stays usable '
        '(UC-10 AF-03)', (tester) async {
      final repository = FakeTwoFactor(
        onStatus: () => active(),
        onDisable: (_, _) => const Failure(
          message: 'That password and code do not match.',
          kind: FailureKind.unauthenticated,
        ),
      );
      await pumpScreen(tester, repository);

      await tester.enterText(
        find.byKey(const Key('twoFactor.password')),
        'wrong',
      );
      await tester.tap(find.byKey(const Key('twoFactor.disable')));
      await tester.pumpAndSettle();

      expect(find.text('That password and code do not match.'), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.password')), findsOneWidget);

      await tester.tap(find.byKey(const Key('twoFactor.regenerate')));
      await tester.pumpAndSettle();

      expect(repository.regenerations, 1);
    });

    testWidgets('Given two-factor is off '
        'When every method is unticked and setup is started '
        'Then it is refused on screen and the methods are still offered', (
      tester,
    ) async {
      final repository = FakeTwoFactor();
      await pumpScreen(tester, repository);

      await tester.tap(find.byKey(const Key('twoFactor.method.app')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();

      expect(find.text('Choose at least one method.'), findsOneWidget);
      expect(repository.enabled, isEmpty);

      await tester.tap(find.byKey(const Key('twoFactor.method.email')));
      await tester.pumpAndSettle();
      final ticked = [
        for (final method in TwoFactorMethod.values)
          if (tester
                  .widget<CheckboxListTile>(
                    find.byKey(Key('twoFactor.method.${method.wireName}')),
                  )
                  .value ??
              false)
            method,
      ];
      await tester.tap(find.byKey(const Key('twoFactor.enable')));
      await tester.pumpAndSettle();

      // Exactly what the boxes show is asked for, email among them.
      expect(ticked, contains(TwoFactorMethod.email));
      expect(repository.enabled.single, ticked);
    });

    testWidgets('Given the status cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry that reads it again', (
      tester,
    ) async {
      var reachable = false;
      await pumpScreen(
        tester,
        FakeTwoFactor(
          onStatus: () => reachable
              ? active()
              : const Failure(
                  message: 'The instance could not be reached.',
                  kind: FailureKind.unreachable,
                ),
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);

      reachable = true;
      await tester.tap(find.byKey(const Key('twoFactor.retry')));
      await tester.pumpAndSettle();

      expect(find.textContaining('is on'), findsOneWidget);
      expect(find.byKey(const Key('twoFactor.retry')), findsNothing);
    });
  });
}
