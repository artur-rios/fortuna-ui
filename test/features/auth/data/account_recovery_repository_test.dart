import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/network/api_client.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/account_recovery_repository.dart';

import '../../../support/api_stub.dart';

const _unreachable = 'The instance could not be reached.';

HttpAccountRecoveryRepository _repository(ApiStub stub) =>
    HttpAccountRecoveryRepository.fromDio(stub.dio);

void main() {
  group('HttpAccountRecoveryRepository.requestPasswordRecovery', () {
    test('Given an address '
        'When a reset message is asked for '
        "Then the address is posted and the API's confirmation is the answer "
        '(UC-09 steps 1-3)', () async {
      final stub = ApiStub.data(
        <String, Object?>{},
        messages: ['If the address is registered, a message was sent.'],
      );

      final result = await _repository(stub)
          .requestPasswordRecovery('ana@example.com');

      expect(
        result,
        const Success('If the address is registered, a message was sent.'),
      );
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/password-recovery');
      expect(stub.body, {'email': 'ana@example.com'});
    });

    test('Given the API confirms without a message '
        'When a reset message is asked for '
        'Then the answer is a fallback that does not reveal whether the '
        'address has an account (UC-09 AF-02)', () async {
      for (final messages in [
        <String>[],
        ['  '],
      ]) {
        final stub = ApiStub.data(<String, Object?>{}, messages: messages);

        final result = await _repository(stub)
            .requestPasswordRecovery('ana@example.com');

        expect(
          result,
          const Success(
            'If that address belongs to an account, a reset message is on its '
            'way.',
          ),
        );
      }
    });

    test('Given the API refuses the request '
        'When a reset message is asked for '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(429, ['Too many requests. Try again later.']),
      );

      final result = await _repository(stub)
          .requestPasswordRecovery('ana@example.com');

      expect(
        result,
        const Failure<String>(
          message: 'Too many requests. Try again later.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a reset message is asked for '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await _repository(stub)
          .requestPasswordRecovery('ana@example.com');

      expect(
        result,
        const Failure<String>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpAccountRecoveryRepository.resetPassword', () {
    test('Given a token and a new password '
        'When the password is reset '
        "Then both are posted and the API's confirmation is the answer "
        '(UC-09 steps 4-6)', () async {
      final stub = ApiStub.data(
        <String, Object?>{},
        messages: ['Password changed.', 'Sign in again.'],
      );

      final result = await _repository(stub)
          .resetPassword(token: 'reset-token', newPassword: 'a new passphrase');

      expect(result, const Success('Password changed. Sign in again.'));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/password-reset');
      expect(stub.body, {
        'token': 'reset-token',
        'newPassword': 'a new passphrase',
      });
    });

    test('Given the API confirms without a message '
        'When the password is reset '
        'Then the answer is a plain confirmation', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final result = await _repository(stub)
          .resetPassword(token: 'reset-token', newPassword: 'a new passphrase');

      expect(result, const Success('Your password has been reset.'));
    });

    test('Given an expired or used token '
        'When the password is reset '
        "Then the API's reason is the failure (UC-09 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The reset link has expired.']),
      );

      final result = await _repository(stub)
          .resetPassword(token: 'old-token', newPassword: 'a new passphrase');

      expect(
        result,
        const Failure<String>(
          message: 'The reset link has expired.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given a password the API refuses '
        'When the password is reset '
        'Then the rule is shown as the API worded it (UC-09 AF-05)', () async {
      final stub = ApiStub(
        (_) => refusal(422, ['Password: at least 12 characters.']),
      );

      final result = await _repository(stub)
          .resetPassword(token: 'reset-token', newPassword: 'short');

      expect(
        result,
        const Failure<String>(
          message: 'Password: at least 12 characters.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the password is reset '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await _repository(stub)
          .resetPassword(token: 'reset-token', newPassword: 'a new passphrase');

      expect(
        result,
        const Failure<String>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpAccountRecoveryRepository.verifyEmail', () {
    test('Given the API confirms without a message '
        'When an address is verified '
        'Then it is confirmed with a plain sentence', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final result = await _repository(stub).verifyEmail('verify-token');

      final answer = result.valueOrNull;
      expect(answer, isA<VerifyEmailConfirmed>());
      expect(answer!.message, 'Your email address is verified.');
    });

    test('Given an instance that cannot be reached '
        'When an address is verified '
        'Then it is a failure, not an answer about the password', () async {
      final stub = ApiStub.unreachable();

      final result = await _repository(stub).verifyEmail('verify-token');

      expect(
        result,
        const Failure<VerifyEmailAnswer>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpAccountRecoveryRepository.resendVerification', () {
    test('Given a signed-in, unverified account '
        'When the verification message is asked for again '
        "Then it is posted with no body and the API's confirmation is the "
        'answer', () async {
      final stub = ApiStub.data(
        <String, Object?>{},
        messages: ['Check your inbox.'],
      );

      final result = await _repository(stub).resendVerification();

      expect(result, const Success('Check your inbox.'));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/resend-verification');
      expect(stub.body, isNull);
    });

    test('Given the API confirms without a message '
        'When the verification message is asked for again '
        'Then the answer is a plain confirmation', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final result = await _repository(stub).resendVerification();

      expect(result, const Success('A new verification message was sent.'));
    });

    test('Given an address that is already verified '
        'When the verification message is asked for again '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['The address is already verified.']),
      );

      final result = await _repository(stub).resendVerification();

      expect(
        result,
        const Failure<String>(
          message: 'The address is already verified.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the verification message is asked for again '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await _repository(stub).resendVerification();

      expect(
        result,
        const Failure<String>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('accountRecoveryRepositoryProvider', () {
    test('Given the shared client '
        'When the repository is asked for '
        'Then it sends its requests through that client', () async {
      final stub = ApiStub.data(<String, Object?>{});
      final container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(stub.dio)],
      );
      addTearDown(container.dispose);

      final repository = container.read(accountRecoveryRepositoryProvider);
      await repository.resendVerification();

      expect(repository, isA<HttpAccountRecoveryRepository>());
      expect(stub.request.path, '/api/auth/resend-verification');
    });
  });
}
