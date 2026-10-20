/// Creating an account with a name, an address and a password (UC-47).
///
/// The API answers a free and a taken address with the same message, and this
/// repository does nothing that could tell them apart — it returns whatever the
/// API said. Only a closed instance, a malformed request or an unreachable one
/// answer differently, and none of those says anything about an address.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

abstract interface class RegistrationRepository {
  /// Asks the instance to create an account (`UC-47` steps 2-4).
  ///
  /// The password is passed here and nowhere else: it is not stored, not
  /// logged, and not retained for a retry.
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  });
}

class HttpRegistrationRepository implements RegistrationRepository {
  HttpRegistrationRepository(this._client);

  factory HttpRegistrationRepository.fromDio(Dio dio) =>
      HttpRegistrationRepository(AuthClient(dio));

  final AuthClient _client;

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.postApiAuthRegister(
        body: RegisterThroughApiCommand(
          name: name,
          email: email,
          password: password,
        ),
      );

      final message = (response.messages ?? const <String>[]).join(' ').trim();

      return Success(
        message.isEmpty
            ? "If this address can be registered, we've sent it an email. "
                  'Follow it, then sign in.'
            : message,
      );
    } on DioException catch (exception) {
      return failureFromDioException<String>(exception);
    }
  }
}

final registrationRepositoryProvider = Provider<RegistrationRepository>(
  (ref) => HttpRegistrationRepository.fromDio(ref.watch(dioProvider)),
);
