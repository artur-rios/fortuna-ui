import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/local_account_repository.dart';

import '../../../support/api_stub.dart';

const _unreachable = 'The instance could not be reached.';

void main() {
  group('HttpLocalAccountRepository.create', () {
    test('Given a name and a secret '
        'When the local account is created '
        'Then they are posted and the codes and warning come back as the core '
        'sent them (UC-06 main flow)', () async {
      final stub = ApiStub.data({
        'id': 'la1',
        'displayName': 'Ada',
        'recoveryCodes': ['aaaa-1111', 'bbbb-2222'],
        'recoveryWarning': 'Lose these and the account is gone.',
      }, status: 201);

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .create(displayName: 'Ada', secret: 'local secret');

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/local-accounts');
      expect(stub.body, {
        'displayName': 'Ada',
        'secret': 'local secret',
        'storageMode': null,
      });
      final created = result.valueOrNull!;
      expect(created.displayName, 'Ada');
      expect(created.recoveryCodes, ['aaaa-1111', 'bbbb-2222']);
      expect(created.warning, 'Lose these and the account is gone.');
    });

    test('Given an answer naming no account and no warning '
        'When the local account is created '
        'Then the name typed is kept and there is no warning', () async {
      final stub = ApiStub.data({
        'recoveryCodes': ['aaaa-1111'],
      }, status: 201);

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .create(displayName: 'Ada', secret: 'local secret');

      final created = result.valueOrNull!;
      expect(created.displayName, 'Ada');
      expect(created.recoveryCodes, ['aaaa-1111']);
      expect(created.warning, isNull);
    });

    test('Given an answer with no data or no recovery codes '
        'When the local account is created '
        'Then it is a failure rather than an account with no way back '
        '(UC-06 AF-03)', () async {
      for (final data in [
        null,
        {'displayName': 'Ada'},
        {'displayName': 'Ada', 'recoveryCodes': <String>[]},
      ]) {
        final stub = ApiStub.data(data, status: 201);

        final result = await HttpLocalAccountRepository.fromDio(stub.dio)
            .create(displayName: 'Ada', secret: 'local secret');

        expect(
          result,
          const Failure<CreatedLocalAccount>(
            message:
                'The account was not created with recovery codes. Nothing has '
                'been set up; please try again.',
            kind: FailureKind.serverError,
          ),
        );
      }
    });

    test('Given a local account already exists '
        'When another is created '
        "Then the core's reason is the failure (UC-06 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A local account already exists.']),
      );

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .create(displayName: 'Ada', secret: 'local secret');

      expect(
        result,
        const Failure<CreatedLocalAccount>(
          message: 'A local account already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a core that does not offer local accounts '
        'When the local account is created '
        "Then the core's reason is the failure, as unavailable offline "
        '(UC-06 AF-05)', () async {
      final stub = ApiStub(
        (_) => refusal(501, ['Local accounts are not enabled.']),
      );

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .create(displayName: 'Ada', secret: 'local secret');

      expect(
        result,
        const Failure<CreatedLocalAccount>(
          message: 'Local accounts are not enabled.',
          kind: FailureKind.unavailableOffline,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the local account is created '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .create(displayName: 'Ada', secret: 'local secret');

      expect(
        result,
        const Failure<CreatedLocalAccount>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpLocalAccountRepository.authenticate', () {
    test(
      'Given the right name and secret '
      'When the local account is authenticated '
      'Then they are posted and the token is the result (UC-07 main flow)',
      () async {
        final stub = ApiStub.data({
          'token': 'session-token',
          'expiresAt': '2026-11-16T13:00:00.000Z',
        });

        final result = await HttpLocalAccountRepository.fromDio(stub.dio)
            .authenticate(name: 'Ada', secret: 'local secret');

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/local-accounts/authenticate');
        expect(stub.body, {'name': 'Ada', 'secret': 'local secret'});
        expect(result, const Success('session-token'));
      },
    );

    test('Given an answer with no data or no token '
        'When the local account is authenticated '
        'Then no session is granted', () async {
      for (final data in [
        null,
        <String, Object?>{},
        {'token': ''},
      ]) {
        final stub = ApiStub.data(data);

        final result = await HttpLocalAccountRepository.fromDio(stub.dio)
            .authenticate(name: 'Ada', secret: 'local secret');

        expect(
          result,
          const Failure<String>(
            message: 'The core granted no session.',
            kind: FailureKind.unauthenticated,
          ),
        );
      }
    });

    test(
      'Given a wrong name or secret '
      'When the local account is authenticated '
      "Then the core's one message is passed through (UC-07 AF-02)",
      () async {
        final stub = ApiStub(
          (_) => refusal(401, ['The name or secret is incorrect.']),
        );

        final result = await HttpLocalAccountRepository.fromDio(stub.dio)
            .authenticate(name: 'Ada', secret: 'wrong');

        expect(
          result,
          const Failure<String>(
            message: 'The name or secret is incorrect.',
            kind: FailureKind.unauthenticated,
          ),
        );
      },
    );

    test('Given an instance that cannot be reached '
        'When the local account is authenticated '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .authenticate(name: 'Ada', secret: 'local secret');

      expect(
        result,
        const Failure<String>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpLocalAccountRepository.recover', () {
    test('Given a valid recovery code '
        'When the account is recovered '
        'Then the code and new secret are posted and the session comes back '
        'with the codes left (UC-08 main flow)', () async {
      final stub = ApiStub.data({
        'token': 'session-token',
        'remainingRecoveryCodes': 7,
      });

      final result = await HttpLocalAccountRepository.fromDio(stub.dio).recover(
        name: 'Ada',
        recoveryCode: 'aaaa-1111',
        newSecret: 'new secret',
      );

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/local-accounts/recover');
      expect(stub.body, {
        'name': 'Ada',
        'newSecret': 'new secret',
        'recoveryCode': 'aaaa-1111',
      });
      final recovered = result.valueOrNull!;
      expect(recovered.token, 'session-token');
      expect(recovered.remainingRecoveryCodes, 7);
    });

    test('Given an answer that does not say how many codes are left '
        'When the account is recovered '
        'Then none are counted as left (UC-08 AF-04)', () async {
      final stub = ApiStub.data({'token': 'session-token'});

      final result = await HttpLocalAccountRepository.fromDio(stub.dio).recover(
        name: 'Ada',
        recoveryCode: 'aaaa-1111',
        newSecret: 'new secret',
      );

      expect(result.valueOrNull!.remainingRecoveryCodes, 0);
    });

    test('Given an answer with no data or no token '
        'When the account is recovered '
        'Then no session is granted', () async {
      for (final data in [
        null,
        {'remainingRecoveryCodes': 7},
        {'token': '', 'remainingRecoveryCodes': 7},
      ]) {
        final stub = ApiStub.data(data);

        final result = await HttpLocalAccountRepository.fromDio(stub.dio)
            .recover(
              name: 'Ada',
              recoveryCode: 'aaaa-1111',
              newSecret: 'new secret',
            );

        expect(
          result,
          const Failure<RecoveredLocalAccount>(
            message: 'The core granted no session.',
            kind: FailureKind.unauthenticated,
          ),
        );
      }
    });

    test('Given a wrong or spent recovery code '
        'When the account is recovered '
        "Then the core's reason is the failure (UC-08 AF-01, AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The recovery code is not valid.']),
      );

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .recover(name: 'Ada', recoveryCode: 'spent', newSecret: 'new secret');

      expect(
        result,
        const Failure<RecoveredLocalAccount>(
          message: 'The recovery code is not valid.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the account is recovered '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpLocalAccountRepository.fromDio(stub.dio).recover(
        name: 'Ada',
        recoveryCode: 'aaaa-1111',
        newSecret: 'new secret',
      );

      expect(
        result,
        const Failure<RecoveredLocalAccount>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpLocalAccountRepository.regenerateRecoveryCodes', () {
    test('Given the right secret '
        'When the recovery codes are regenerated '
        'Then the secret is posted and the new codes and warning come back '
        '(UC-08 step 6)', () async {
      final stub = ApiStub.data({
        'recoveryCodes': ['cccc-3333', 'dddd-4444'],
        'recoveryWarning': 'Your old codes no longer work.',
      });

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(secret: 'local secret');

      expect(stub.request.method, 'POST');
      expect(
        stub.request.path,
        '/api/local-accounts/recovery-codes/regenerate',
      );
      expect(stub.body, {'secret': 'local secret'});
      final created = result.valueOrNull!;
      expect(created.displayName, '');
      expect(created.recoveryCodes, ['cccc-3333', 'dddd-4444']);
      expect(created.warning, 'Your old codes no longer work.');
    });

    test('Given new codes without a warning '
        'When the recovery codes are regenerated '
        'Then there is no warning', () async {
      final stub = ApiStub.data({
        'recoveryCodes': ['cccc-3333'],
      });

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(secret: 'local secret');

      expect(result.valueOrNull!.warning, isNull);
    });

    test(
      'Given an answer with no data or no codes '
      'When the recovery codes are regenerated '
      'Then it is a failure saying the old codes still work (UC-08 AF-05)',
      () async {
        for (final data in [
          null,
          <String, Object?>{},
          {'recoveryCodes': <String>[]},
        ]) {
          final stub = ApiStub.data(data);

          final result = await HttpLocalAccountRepository.fromDio(stub.dio)
              .regenerateRecoveryCodes(secret: 'local secret');

          expect(
            result,
            const Failure<CreatedLocalAccount>(
              message:
                  'No new recovery codes were issued. Your existing codes are '
                  'still valid.',
              kind: FailureKind.serverError,
            ),
          );
        }
      },
    );

    test('Given a wrong secret '
        'When the recovery codes are regenerated '
        "Then the core's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The secret is incorrect.']));

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(secret: 'wrong');

      expect(
        result,
        const Failure<CreatedLocalAccount>(
          message: 'The secret is incorrect.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the recovery codes are regenerated '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpLocalAccountRepository.fromDio(stub.dio)
          .regenerateRecoveryCodes(secret: 'local secret');

      expect(
        result,
        const Failure<CreatedLocalAccount>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
