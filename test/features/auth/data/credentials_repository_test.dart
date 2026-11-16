import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/credentials_repository.dart';

import '../../../support/api_stub.dart';

const _noSession = Failure<SignInGranted>(
  message: 'The instance granted no session.',
  kind: FailureKind.unauthenticated,
);

/// The time the repository's clock reads in these tests.
final _now = DateTime(2026, 11, 16, 9, 30);

Future<Result<SignInOutcome>> _signIn(ApiStub stub) =>
    HttpCredentialsRepository.fromDio(
      stub.dio,
      clock: () => _now,
    ).signIn(email: 'ada@example.com', password: 'correct horse');

void main() {
  group('HttpCredentialsRepository.signIn', () {
    test(
      'Given credentials the API accepts '
      'When they are submitted '
      'Then they are posted once and a session is granted (UC-03 main flow)',
      () async {
        final stub = ApiStub.data({
          'token': 'session-token',
          'emailVerified': true,
          'requiresTwoFactor': false,
        });

        final result = await _signIn(stub);

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/auth/login');
        expect(stub.body, {
          'email': 'ada@example.com',
          'password': 'correct horse',
        });
        final granted = result.valueOrNull! as SignInGranted;
        expect(granted.token, 'session-token');
        expect(granted.emailVerified, isTrue);
      },
    );

    test(
      'Given the API grants a session to an unverified address '
      'When the credentials are submitted '
      'Then the session is granted and the address is marked unverified',
      () async {
        final stub = ApiStub.data({
          'token': 'session-token',
          'emailVerified': false,
        });

        final result = await _signIn(stub);

        final granted = result.valueOrNull! as SignInGranted;
        expect(granted.emailVerified, isFalse);
      },
    );

    test('Given a grant that says nothing about the address or a second factor '
        'When the credentials are submitted '
        'Then it is a session with the address taken as verified', () async {
      final stub = ApiStub.data({'token': 'session-token'});

      final result = await _signIn(stub);

      final granted = result.valueOrNull! as SignInGranted;
      expect(granted.token, 'session-token');
      expect(granted.emailVerified, isTrue);
    });

    test('Given the API asks for a second factor '
        'When the credentials are submitted '
        'Then it is a challenge carrying its token, methods and expiry '
        '(UC-03 AF-03)', () async {
      final stub = ApiStub.data({
        'requiresTwoFactor': true,
        'challengeToken': 'challenge-token',
        'availableMethods': ['app', 'email'],
        'expiresAt': '2026-11-16T12:05:00.000Z',
      });

      final result = await _signIn(stub);

      final challenge = result.valueOrNull! as SignInChallenged;
      expect(challenge.challengeToken, 'challenge-token');
      expect(challenge.methods, ['app', 'email']);
      expect(challenge.expiresAt, DateTime.utc(2026, 11, 16, 12, 5));
    });

    test(
      'Given an answer carrying both a challenge and a token '
      'When the credentials are submitted '
      'Then it is still a challenge, not a session (UC-03 AF-03, BR-19)',
      () async {
        final stub = ApiStub.data({
          'requiresTwoFactor': true,
          'challengeToken': 'challenge-token',
          'token': 'session-token',
          'expiresAt': '2026-11-16T12:05:00.000Z',
        });

        final result = await _signIn(stub);

        expect(result.valueOrNull, isA<SignInChallenged>());
      },
    );

    test(
      'Given a challenge naming no methods and no expiry '
      'When the credentials are submitted '
      'Then it is a challenge with no methods and an expiry of its own',
      () async {
        final stub = ApiStub.data({
          'requiresTwoFactor': true,
          'challengeToken': 'challenge-token',
        });

        final result = await _signIn(stub);

        final challenge = result.valueOrNull! as SignInChallenged;
        expect(challenge.challengeToken, 'challenge-token');
        expect(challenge.methods, isEmpty);
        expect(challenge.expiresAt, _now.add(const Duration(minutes: 5)));
      },
    );

    test('Given the API asks for a second factor but issues no challenge '
        'When the credentials are submitted '
        'Then it is a failure asking to try again', () async {
      for (final challengeToken in [null, '']) {
        final stub = ApiStub.data({
          'requiresTwoFactor': true,
          'challengeToken': challengeToken,
          'token': 'session-token',
        });

        final result = await _signIn(stub);

        expect(
          result,
          const Failure<SignInOutcome>(
            message:
                'The instance asked for a second factor but issued no '
                'challenge. Please try again.',
            kind: FailureKind.serverError,
          ),
        );
      }
    });

    test('Given an answer with no data '
        'When the credentials are submitted '
        'Then it is a failure saying the instance did not answer', () async {
      final stub = ApiStub.data(null);

      final result = await _signIn(stub);

      expect(
        result,
        const Failure<SignInOutcome>(
          message: 'The instance did not answer the sign-in.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an answer granting neither a challenge nor a token '
        'When the credentials are submitted '
        'Then no session is granted', () async {
      for (final token in [null, '']) {
        final stub = ApiStub.data({'requiresTwoFactor': false, 'token': token});

        final result = await _signIn(stub);

        expect(
          result,
          const Failure<SignInOutcome>(
            message: 'The instance granted no session.',
            kind: FailureKind.unauthenticated,
          ),
        );
      }
    });

    test('Given the API refuses the credentials '
        'When they are submitted '
        "Then the API's own reason is the failure, unclassified "
        '(UC-03 AF-02, FR-SE-23)', () async {
      final stub = ApiStub(
        (_) => refusal(401, ['The email or password is incorrect.']),
      );

      final result = await _signIn(stub);

      expect(
        result,
        const Failure<SignInOutcome>(
          message: 'The email or password is incorrect.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given the API refuses an unverified address '
        'When the credentials are submitted '
        "Then the API's reason is the failure (UC-03 AF-06)", () async {
      final stub = ApiStub(
        (_) => refusal(403, ['Verify your email address first.']),
      );

      final result = await _signIn(stub);

      expect(
        result,
        const Failure<SignInOutcome>(
          message: 'Verify your email address first.',
          kind: FailureKind.forbidden,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the credentials are submitted '
        'Then it is a failure saying so (UC-03 AF-04)', () async {
      final stub = ApiStub.unreachable();

      final result = await _signIn(stub);

      expect(
        result,
        const Failure<SignInOutcome>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCredentialsRepository.exchangeGoogleIdToken', () {
    test(
      'Given a Google ID token the API accepts '
      'When it is exchanged '
      'Then it is posted and a session is granted (UC-05 main flow)',
      () async {
        final stub = ApiStub.data({
          'token': 'session-token',
          'emailVerified': false,
        });

        final result = await HttpCredentialsRepository.fromDio(stub.dio)
            .exchangeGoogleIdToken('google-id-token');

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/auth/google');
        expect(stub.body, {'idToken': 'google-id-token'});
        expect(result.valueOrNull!.token, 'session-token');
        expect(result.valueOrNull!.emailVerified, isFalse);
      },
    );

    test('Given a grant that says nothing about the address '
        'When the token is exchanged '
        'Then the address is taken as verified', () async {
      final stub = ApiStub.data({'token': 'session-token'});

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .exchangeGoogleIdToken('google-id-token');

      expect(result.valueOrNull!.emailVerified, isTrue);
    });

    test('Given an answer with no data or no token '
        'When the token is exchanged '
        'Then no session is granted', () async {
      for (final data in [
        null,
        <String, Object?>{},
        {'token': ''},
      ]) {
        final stub = ApiStub.data(data);

        final result = await HttpCredentialsRepository.fromDio(stub.dio)
            .exchangeGoogleIdToken('google-id-token');

        expect(result, _noSession);
      }
    });

    test('Given the API will not link an account that has a password '
        'When the token is exchanged '
        "Then the API's reason is the failure (UC-05 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['This account signs in with a password.']),
      );

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .exchangeGoogleIdToken('google-id-token');

      expect(
        result,
        const Failure<SignInGranted>(
          message: 'This account signs in with a password.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given the API rejects the ID token '
        'When it is exchanged '
        "Then the API's reason is the failure (UC-05 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(401, ['The Google sign-in could not be verified.']),
      );

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .exchangeGoogleIdToken('google-id-token');

      expect(
        result,
        const Failure<SignInGranted>(
          message: 'The Google sign-in could not be verified.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the token is exchanged '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .exchangeGoogleIdToken('google-id-token');

      expect(
        result,
        const Failure<SignInGranted>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCredentialsRepository.verifyTwoFactor', () {
    test('Given a code for an outstanding challenge '
        'When it is submitted '
        'Then it is posted with the challenge and a session is granted '
        '(UC-04 main flow)', () async {
      final stub = ApiStub.data({
        'token': 'session-token',
        'emailVerified': true,
      });

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .verifyTwoFactor(challengeToken: 'challenge-token', code: '123456');

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/auth/2fa/verify');
      expect(stub.body, {
        'challengeToken': 'challenge-token',
        'code': '123456',
        'recoveryCode': null,
      });
      expect(result.valueOrNull!.token, 'session-token');
      expect(result.valueOrNull!.emailVerified, isTrue);
    });

    test('Given a recovery code instead of a code '
        'When it is submitted '
        'Then the recovery code is sent and the code left out', () async {
      final stub = ApiStub.data({'token': 'session-token'});

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .verifyTwoFactor(
            challengeToken: 'challenge-token',
            recoveryCode: 'abcd-efgh',
          );

      expect(stub.body, {
        'challengeToken': 'challenge-token',
        'code': null,
        'recoveryCode': 'abcd-efgh',
      });
      expect(result.valueOrNull!.emailVerified, isTrue);
    });

    test('Given a grant for an unverified address '
        'When the code is submitted '
        'Then the address is marked unverified', () async {
      final stub = ApiStub.data({
        'token': 'session-token',
        'emailVerified': false,
      });

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .verifyTwoFactor(challengeToken: 'challenge-token', code: '123456');

      expect(result.valueOrNull!.emailVerified, isFalse);
    });

    test('Given an answer with no data or no token '
        'When the code is submitted '
        'Then no session is granted', () async {
      for (final data in [
        null,
        <String, Object?>{},
        {'token': ''},
      ]) {
        final stub = ApiStub.data(data);

        final result = await HttpCredentialsRepository.fromDio(stub.dio)
            .verifyTwoFactor(challengeToken: 'challenge-token', code: '123456');

        expect(result, _noSession);
      }
    });

    test('Given the API refuses the code '
        'When it is submitted '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(401, ['The code is invalid or has expired.']),
      );

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .verifyTwoFactor(challengeToken: 'challenge-token', code: '000000');

      expect(
        result,
        const Failure<SignInGranted>(
          message: 'The code is invalid or has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the code is submitted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCredentialsRepository.fromDio(stub.dio)
          .verifyTwoFactor(challengeToken: 'challenge-token', code: '123456');

      expect(
        result,
        const Failure<SignInGranted>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
