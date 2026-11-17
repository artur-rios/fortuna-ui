import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/two_factor_repository.dart';

import '../../../support/api_stub.dart';

const _unreachable = 'The instance could not be reached.';

const _noNewCodes = Failure<List<String>>(
  message:
      'No new recovery codes were issued. Your existing codes are still '
      'valid.',
  kind: FailureKind.serverError,
);

const _notConfirmed = Failure<List<String>>(
  message: 'The setup was not confirmed. Try the code again.',
  kind: FailureKind.invalidInput,
);

void main() {
  group('TwoFactorMethod', () {
    test('Given each second factor '
        'When it is named '
        'Then it carries the wire name the API uses and the label shown', () {
      final names = {
        for (final method in TwoFactorMethod.values)
          method: (method.wireName, method.label),
      };

      expect(names, {
        TwoFactorMethod.app: ('app', 'Authenticator app'),
        TwoFactorMethod.email: ('email', 'Email'),
      });
    });
  });

  group('HttpTwoFactorRepository.status', () {
    test('Given an account with the authenticator app on '
        'When the status is read '
        "Then it is fetched and mapped with the API's own figures "
        '(UC-10 main flow)', () async {
      final stub = ApiStub.data({
        'isActive': true,
        'appEnabled': true,
        'emailEnabled': false,
        'remainingRecoveryCodes': 8,
      });

      final result = await HttpTwoFactorRepository.fromDio(stub.dio).status();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/auth/2fa');
      final status = result.valueOrNull!;
      expect(status.isActive, isTrue);
      expect(status.appEnabled, isTrue);
      expect(status.emailEnabled, isFalse);
      expect(status.remainingRecoveryCodes, 8);
      expect(status.methods, [TwoFactorMethod.app]);
    });

    test('Given an account with only emailed codes on '
        'When the status is read '
        'Then email is its only method', () async {
      final stub = ApiStub.data({
        'isActive': true,
        'appEnabled': false,
        'emailEnabled': true,
        'remainingRecoveryCodes': 3,
      });

      final result = await HttpTwoFactorRepository.fromDio(stub.dio).status();

      expect(result.valueOrNull!.methods, [TwoFactorMethod.email]);
    });

    test('Given an answer with no data '
        'When the status is read '
        'Then two-factor reads as off with no codes', () async {
      final stub = ApiStub.data(null);

      final result = await HttpTwoFactorRepository.fromDio(stub.dio).status();

      final status = result.valueOrNull!;
      expect(status.isActive, isFalse);
      expect(status.appEnabled, isFalse);
      expect(status.emailEnabled, isFalse);
      expect(status.remainingRecoveryCodes, 0);
      expect(status.methods, isEmpty);
    });

    test('Given an account that cannot hold a second factor '
        'When the status is read '
        "Then the API's reason is the failure (UC-10 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(403, [
          'Accounts that sign in with Google cannot use two-factor.',
        ]),
      );

      final result = await HttpTwoFactorRepository.fromDio(stub.dio).status();

      expect(
        result,
        const Failure<TwoFactorStatus>(
          message: 'Accounts that sign in with Google cannot use two-factor.',
          kind: FailureKind.forbidden,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the status is read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTwoFactorRepository.fromDio(stub.dio).status();

      expect(
        result,
        const Failure<TwoFactorStatus>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTwoFactorRepository.enable', () {
    test('Given both methods chosen '
        'When a setup is started '
        'Then their wire names are posted and the setup carries the URI and '
        'its secret (FR-SE-12, FR-SE-13)', () async {
      final stub = ApiStub.data({
        'otpAuthUri':
            'otpauth://totp/Fortuna:ada?secret=JBSWY3DPEHPK3PXP&issuer=Fortuna',
        'emailCodeSent': true,
      });

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .enable([TwoFactorMethod.app, TwoFactorMethod.email]);

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/2fa/enable');
      expect(stub.body, {
        'methods': ['app', 'email'],
      });
      final setup = result.valueOrNull!;
      expect(
        setup.otpAuthUri,
        'otpauth://totp/Fortuna:ada?secret=JBSWY3DPEHPK3PXP&issuer=Fortuna',
      );
      expect(setup.sharedSecret, 'JBSWY3DPEHPK3PXP');
      expect(setup.emailCodeSent, isTrue);
    });

    test('Given an answer with no data '
        'When a setup is started '
        'Then there is no URI, no secret and no emailed code', () async {
      final stub = ApiStub.data(null);

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .enable([TwoFactorMethod.email]);

      expect(stub.body, {
        'methods': ['email'],
      });
      final setup = result.valueOrNull!;
      expect(setup.otpAuthUri, isNull);
      expect(setup.sharedSecret, isNull);
      expect(setup.emailCodeSent, isFalse);
    });

    test('Given two-factor is already on '
        'When a setup is started '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Two-factor authentication is already on.']),
      );

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .enable([TwoFactorMethod.app]);

      expect(
        result,
        const Failure<TwoFactorSetup>(
          message: 'Two-factor authentication is already on.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a setup is started '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .enable([TwoFactorMethod.app]);

      expect(
        result,
        const Failure<TwoFactorSetup>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTwoFactorRepository.confirm', () {
    test('Given the right code '
        'When the setup is confirmed '
        'Then the code is posted and the recovery codes are the result '
        '(FR-SE-14)', () async {
      final stub = ApiStub.data({
        'enabled': true,
        'recoveryCodes': ['aaaa-1111', 'bbbb-2222'],
      });

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .confirm(appCode: '123456');

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/2fa/confirm');
      expect(stub.body, {'appCode': '123456'});
      expect(result.valueOrNull, ['aaaa-1111', 'bbbb-2222']);
    });

    test('Given an emailed code '
        'When the setup is confirmed '
        'Then it is sent as the email code', () async {
      final stub = ApiStub.data({
        'enabled': true,
        'recoveryCodes': ['aaaa-1111'],
      });

      await HttpTwoFactorRepository.fromDio(stub.dio)
          .confirm(emailCode: '654321');

      expect(stub.body, {'emailCode': '654321'});
    });

    test('Given a confirmation the API marked enabled but sent no codes for '
        'When the setup is confirmed '
        'Then it succeeds with no codes', () async {
      final stub = ApiStub.data({'enabled': true});

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .confirm(appCode: '123456');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test(
      'Given an answer that does not mark the setup enabled '
      'When the setup is confirmed '
      'Then it is a failure asking for the code again, codes or not',
      () async {
        for (final data in [
          null,
          {
            'recoveryCodes': ['aaaa-1111'],
          },
          {
            'enabled': false,
            'recoveryCodes': ['aaaa-1111'],
          },
        ]) {
          final stub = ApiStub.data(data);

          final result = await HttpTwoFactorRepository.fromDio(stub.dio)
              .confirm(appCode: '123456');

          expect(result, _notConfirmed);
        }
      },
    );

    test('Given a wrong or expired code '
        'When the setup is confirmed '
        "Then the API's reason is the failure (UC-10 AF-01)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The code is invalid or has expired.']),
      );

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .confirm(appCode: '000000');

      expect(
        result,
        const Failure<List<String>>(
          message: 'The code is invalid or has expired.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the setup is confirmed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .confirm(appCode: '123456');

      expect(
        result,
        const Failure<List<String>>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTwoFactorRepository.disable', () {
    test('Given the password and a code '
        'When two-factor is turned off '
        'Then both are posted and it succeeds (FR-SE-15)', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .disable(password: 'correct horse', code: '123456');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/2fa/disable');
      expect(stub.body, {'code': '123456', 'password': 'correct horse'});
    });

    test('Given the password and a recovery code '
        'When two-factor is turned off '
        'Then the recovery code is sent and the code left out', () async {
      final stub = ApiStub.data(null);

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .disable(password: 'correct horse', recoveryCode: 'aaaa-1111');

      expect(result, const Success<void>(null));
      expect(stub.body, {
        'password': 'correct horse',
        'recoveryCode': 'aaaa-1111',
      });
    });

    test('Given a wrong password or second factor '
        'When two-factor is turned off '
        "Then the API's reason is the failure (UC-10 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(401, ['The password or code is incorrect.']),
      );

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .disable(password: 'wrong', code: '000000');

      expect(
        result,
        const Failure<void>(
          message: 'The password or code is incorrect.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given two-factor is not on '
        'When it is turned off '
        "Then the API's reason is the failure (UC-10 AF-04)", () async {
      final stub = ApiStub(
        (_) => refusal(404, ['Two-factor authentication is not on.']),
      );

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .disable(password: 'correct horse', code: '123456');

      expect(
        result,
        const Failure<void>(
          message: 'Two-factor authentication is not on.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When two-factor is turned off '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .disable(password: 'correct horse', code: '123456');

      expect(
        result,
        const Failure<void>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTwoFactorRepository.regenerateRecoveryCodes', () {
    test(
      'Given a code '
      'When the recovery codes are regenerated '
      'Then it is posted and the new codes are the result (FR-SE-15)',
      () async {
        final stub = ApiStub.data({
          'recoveryCodes': ['cccc-3333', 'dddd-4444'],
        });

        final result = await HttpTwoFactorRepository.fromDio(stub.dio)
            .regenerateRecoveryCodes(code: '123456');

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/auth/2fa/recovery-codes/regenerate');
        expect(stub.body, {'code': '123456'});
        expect(result.valueOrNull, ['cccc-3333', 'dddd-4444']);
      },
    );

    test('Given a recovery code instead of a code '
        'When the recovery codes are regenerated '
        'Then the recovery code is sent and the code left out', () async {
      final stub = ApiStub.data({
        'recoveryCodes': ['cccc-3333'],
      });

      await HttpTwoFactorRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(recoveryCode: 'aaaa-1111');

      expect(stub.body, {'recoveryCode': 'aaaa-1111'});
    });

    test('Given an answer with no data or no codes '
        'When the recovery codes are regenerated '
        'Then it is a failure saying the old codes still work', () async {
      for (final data in [
        null,
        <String, Object?>{},
        {'recoveryCodes': <String>[]},
      ]) {
        final stub = ApiStub.data(data);

        final result = await HttpTwoFactorRepository.fromDio(stub.dio)
            .regenerateRecoveryCodes(code: '123456');

        expect(result, _noNewCodes);
      }
    });

    test('Given a wrong code '
        'When the recovery codes are regenerated '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The code is incorrect.']));

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(code: '000000');

      expect(
        result,
        const Failure<List<String>>(
          message: 'The code is incorrect.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the recovery codes are regenerated '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTwoFactorRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(code: '123456');

      expect(
        result,
        const Failure<List<String>>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
