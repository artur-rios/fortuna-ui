/// Password recovery and address verification (UC-09).
///
/// Four operations that share one property: none of them may reveal whether an
/// address belongs to anybody. The API is built that way — it answers a request
/// for an unregistered address exactly as it answers one for a real account —
/// and this client's job is not to undo that by treating the two differently.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What the API said about a verification link, when the link itself was good.
///
/// A link from a sign-up (rather than from an existing account's address
/// change) creates the account only once the password chosen at sign-up is
/// repeated, so "the link is good" has three answers, not one.
@immutable
sealed class VerifyEmailAnswer {
  const VerifyEmailAnswer(this.message);

  /// The API's own wording.
  final String message;
}

/// `200`: verified, or the account was created.
@immutable
final class VerifyEmailConfirmed extends VerifyEmailAnswer {
  const VerifyEmailConfirmed(super.message);
}

/// `422`: a sign-up link, sent without the password it requires.
@immutable
final class VerifyEmailPasswordNeeded extends VerifyEmailAnswer {
  const VerifyEmailPasswordNeeded(super.message);
}

/// `401`: a sign-up link, sent with a password that is not the chosen one.
@immutable
final class VerifyEmailPasswordWrong extends VerifyEmailAnswer {
  const VerifyEmailPasswordWrong(super.message);
}

abstract interface class AccountRecoveryRepository {
  /// Asks for a password-reset message (`UC-09` steps 1-3).
  Future<Result<String>> requestPasswordRecovery(String email);

  /// Completes the reset with the token from the message (`UC-09` steps 4-6).
  Future<Result<String>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verifies an address with the token from its message (`UC-09` step 7).
  ///
  /// A token that came from signing up also needs the [password] chosen
  /// there; without it the answer is [VerifyEmailPasswordNeeded].
  Future<Result<VerifyEmailAnswer>> verifyEmail(
    String token, {
    String? password,
  });

  /// Asks for the verification message again.
  ///
  /// Identified by the session's own token, so this is only reachable while
  /// signed in — which is the state an unverified account is in.
  Future<Result<String>> resendVerification();
}

class HttpAccountRecoveryRepository implements AccountRecoveryRepository {
  HttpAccountRecoveryRepository(this._client);

  factory HttpAccountRecoveryRepository.fromDio(Dio dio) =>
      HttpAccountRecoveryRepository(AuthClient(dio));

  final AuthClient _client;

  /// The API's own confirmation, or a plain fallback where it sent none.
  ///
  /// The message matters more here than almost anywhere else: `AF-02` and
  /// `AF-06` are both cases where the *wording* is the behavior.
  static String _messageOr(List<String>? messages, String fallback) {
    final joined = (messages ?? const <String>[]).join(' ').trim();
    return joined.isEmpty ? fallback : joined;
  }

  @override
  Future<Result<String>> requestPasswordRecovery(String email) async {
    try {
      final response = await _client.postApiAuthPasswordRecovery(
        body: RequestPasswordRecoveryThroughApiCommand(email: email),
      );

      return Success(
        _messageOr(
          response.messages,
          'If that address belongs to an account, a reset message is on its '
          'way.',
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<String>(exception);
    }
  }

  @override
  Future<Result<String>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _client.postApiAuthPasswordReset(
        body: ResetPasswordThroughApiCommand(
          token: token,
          newPassword: newPassword,
        ),
      );

      return Success(
        _messageOr(response.messages, 'Your password has been reset.'),
      );
    } on DioException catch (exception) {
      // AF-03 and AF-05 both land here. A refused password carries whatever
      // rule the client did not enforce, and it is shown as the API worded it
      // (FR-DA-15).
      return failureFromDioException<String>(exception);
    }
  }

  @override
  Future<Result<VerifyEmailAnswer>> verifyEmail(
    String token, {
    String? password,
  }) async {
    try {
      final response = await _client.postApiAuthVerifyEmail(
        body: VerifyEmailThroughApiCommand(token: token, password: password),
      );

      return Success(
        VerifyEmailConfirmed(
          _messageOr(response.messages, 'Your email address is verified.'),
        ),
      );
    } on DioException catch (exception) {
      final status = exception.response?.statusCode;
      final failure = failureFromDioException<VerifyEmailAnswer>(exception);

      // 422 and 401 are answers here, not failures. Both mean the link is
      // good and the password is the question: 422 "you did not give one",
      // 401 "that is not the one you chose". Reading them as failures would
      // fold both into invalidInput/unauthenticated and lose the difference
      // between "ask" and "ask again". A 400 — a bad, expired or used link, or
      // the tenth wrong password — stays a failure.
      return switch (status) {
        422 => Success(VerifyEmailPasswordNeeded(failure.message)),
        401 => Success(VerifyEmailPasswordWrong(failure.message)),
        _ => failure,
      };
    }
  }

  @override
  Future<Result<String>> resendVerification() async {
    try {
      final response = await _client.postApiAuthResendVerification();

      return Success(
        _messageOr(response.messages, 'A new verification message was sent.'),
      );
    } on DioException catch (exception) {
      return failureFromDioException<String>(exception);
    }
  }
}

final accountRecoveryRepositoryProvider = Provider<AccountRecoveryRepository>(
  (ref) => HttpAccountRecoveryRepository.fromDio(ref.watch(dioProvider)),
);
