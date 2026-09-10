/// Exchanging credentials for a session (UC-03, UC-04).
///
/// The API answers a sign-in with one of two things — a token, or a two-factor
/// challenge — and both arrive in the same response object. This models them as
/// two outcomes so a caller cannot read a challenge as a session by forgetting
/// to check a boolean (`FR-SE-04`).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What the API did with a credential.
@immutable
sealed class SignInOutcome {
  const SignInOutcome();
}

/// A session was granted.
@immutable
final class SignInGranted extends SignInOutcome {
  const SignInGranted({required this.token, required this.emailVerified});

  final String token;

  /// Whether the API considers the address verified. `AF-06` only arises where
  /// the API refuses on this; a verified-false that still granted a token is
  /// the API's call to make, not this client's.
  final bool emailVerified;
}

/// A second factor is required before there is a session (`AF-03`).
@immutable
final class SignInChallenged extends SignInOutcome {
  const SignInChallenged({
    required this.challengeToken,
    required this.methods,
    required this.expiresAt,
  });

  final String challengeToken;
  final List<String> methods;
  final DateTime expiresAt;
}

abstract interface class CredentialsRepository {
  /// Submits [email] and [password].
  ///
  /// The credential is passed here and nowhere else: it is not stored, not
  /// logged, and not retained for a retry (`AF-04`).
  Future<Result<SignInOutcome>> signIn({
    required String email,
    required String password,
  });

  /// Submits a second factor against an outstanding challenge (`UC-04`).
  Future<Result<SignInGranted>> verifyTwoFactor({
    required String challengeToken,
    String? code,
    String? recoveryCode,
  });
}

class HttpCredentialsRepository implements CredentialsRepository {
  HttpCredentialsRepository(this._client);

  factory HttpCredentialsRepository.fromDio(Dio dio) =>
      HttpCredentialsRepository(AuthClient(dio));

  final AuthClient _client;

  @override
  Future<Result<SignInOutcome>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.postApiAuthLogin(
        body: LoginThroughApiCommand(email: email, password: password),
      );

      final output = response.data;
      if (output == null) {
        return const Failure(
          message: 'The instance did not answer the sign-in.',
          kind: FailureKind.serverError,
        );
      }

      // AF-03. Checked before the token, because a response carrying both is
      // still a challenge — a half-authenticated session is a signed-out one
      // with extra steps (BR-19).
      if (output.requiresTwoFactor ?? false) {
        final challengeToken = output.challengeToken;
        final expiresAt = output.expiresAt;

        if (challengeToken == null || challengeToken.isEmpty) {
          return const Failure(
            message:
                'The instance asked for a second factor but issued no '
                'challenge. Please try again.',
            kind: FailureKind.serverError,
          );
        }

        return Success(
          SignInChallenged(
            challengeToken: challengeToken,
            methods: output.availableMethods ?? const [],
            // A challenge with no stated expiry is treated as short-lived
            // rather than eternal.
            expiresAt:
                expiresAt ?? DateTime.now().add(const Duration(minutes: 5)),
          ),
        );
      }

      final token = output.token;
      if (token == null || token.isEmpty) {
        return const Failure(
          message: 'The instance granted no session.',
          kind: FailureKind.unauthenticated,
        );
      }

      return Success(
        SignInGranted(
          token: token,
          emailVerified: output.emailVerified ?? true,
        ),
      );
    } on DioException catch (exception) {
      // AF-02, AF-04 and AF-06 all arrive here, and all carry the API's own
      // message. The client deliberately does not classify them further:
      // FR-SE-23 exists so that "no such account" and "wrong password" stay
      // indistinguishable, and the way to guarantee that is to never look.
      return failureFromDioException<SignInOutcome>(exception);
    }
  }

  @override
  Future<Result<SignInGranted>> verifyTwoFactor({
    required String challengeToken,
    String? code,
    String? recoveryCode,
  }) async {
    try {
      final response = await _client.postApiAuth2faVerify(
        body: VerifyTwoFactorThroughApiCommand(
          challengeToken: challengeToken,
          code: code,
          recoveryCode: recoveryCode,
        ),
      );

      final token = response.data?.token;
      if (token == null || token.isEmpty) {
        return const Failure(
          message: 'The instance granted no session.',
          kind: FailureKind.unauthenticated,
        );
      }

      return Success(
        SignInGranted(
          token: token,
          emailVerified: response.data?.emailVerified ?? true,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<SignInGranted>(exception);
    }
  }
}

final credentialsRepositoryProvider = Provider<CredentialsRepository>(
  (ref) => HttpCredentialsRepository.fromDio(ref.watch(dioProvider)),
);
