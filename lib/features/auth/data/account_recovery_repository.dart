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

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

abstract interface class AccountRecoveryRepository {
  /// Asks for a password-reset message (`UC-09` steps 1-3).
  Future<Result<String>> requestPasswordRecovery(String email);

  /// Completes the reset with the token from the message (`UC-09` steps 4-6).
  Future<Result<String>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verifies an address with the token from its message (`UC-09` step 7).
  Future<Result<String>> verifyEmail(String token);

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
  Future<Result<String>> verifyEmail(String token) async {
    try {
      final response = await _client.postApiAuthVerifyEmail(
        body: VerifyEmailThroughApiCommand(token: token),
      );

      return Success(
        _messageOr(response.messages, 'Your email address is verified.'),
      );
    } on DioException catch (exception) {
      return failureFromDioException<String>(exception);
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
