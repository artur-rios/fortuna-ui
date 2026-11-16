import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/session/data/session_repository.dart';

import '../../../support/api_stub.dart';

void main() {
  group('HttpSessionRepository.verifyCurrentToken', () {
    test('Given a token the API still accepts '
        'When it is verified '
        'Then the profile is fetched and its name and currency are kept '
        '(UC-11 main flow)', () async {
      final stub = ApiStub.data({
        'id': 'u1',
        'displayName': 'Ada',
        'displayCurrency': 'BRL',
        'displayCurrencyRequiresConfirmation': false,
        'createdAt': '2026-01-02T03:04:05.000Z',
      });

      final result = await HttpSessionRepository.fromDio(stub.dio)
          .verifyCurrentToken();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/me');
      final profile = result.valueOrNull!;
      expect(profile.displayName, 'Ada');
      expect(profile.displayCurrency, 'BRL');
    });

    test('Given a profile with no name and no currency '
        'When the token is verified '
        'Then the session holds and both stay absent', () async {
      final stub = ApiStub.data({'id': 'u1'});

      final result = await HttpSessionRepository.fromDio(stub.dio)
          .verifyCurrentToken();

      final profile = result.valueOrNull!;
      expect(profile.displayName, isNull);
      expect(profile.displayCurrency, isNull);
    });

    test('Given an answer naming no profile '
        'When the token is verified '
        'Then the session is not admitted (UC-11 AF-02)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpSessionRepository.fromDio(stub.dio)
          .verifyCurrentToken();

      expect(
        result,
        const Failure<VerifiedProfile>(
          message: 'The instance did not confirm this session.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given the API rejects the token '
        'When it is verified '
        "Then the API's reason is the failure (UC-11 AF-02)", () async {
      final stub = ApiStub((_) => refusal(401, ['The session has expired.']));

      final result = await HttpSessionRepository.fromDio(stub.dio)
          .verifyCurrentToken();

      expect(
        result,
        const Failure<VerifiedProfile>(
          message: 'The session has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance answering that it is unavailable '
        'When the token is verified '
        'Then it is a server failure, not a rejected session', () async {
      final stub = ApiStub(
        (_) => refusal(503, ['The instance is starting up.']),
      );

      final result = await HttpSessionRepository.fromDio(stub.dio)
          .verifyCurrentToken();

      expect(
        result,
        const Failure<VerifiedProfile>(
          message: 'The instance is starting up.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test(
      'Given an instance that cannot be reached '
      'When the token is verified '
      'Then it is a failure saying so, not a rejected session (UC-11 AF-03)',
      () async {
        final stub = ApiStub.unreachable();

        final result = await HttpSessionRepository.fromDio(stub.dio)
            .verifyCurrentToken();

        expect(
          result,
          const Failure<VerifiedProfile>(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        );
      },
    );
  });
}
