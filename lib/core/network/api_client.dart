/// The configured HTTP client (IR-08, FR-DA-12).
///
/// One `dio` instance, shared by every generated client, carrying the base
/// address, the timeouts and the bearer-token interceptor. The token is
/// attached to the `Authorization` header and **never** placed in a URL, where
/// it would reach logs, history and referrers.
library;

import 'package:dio/dio.dart';

import '../result/result.dart';
import '../storage/token_store.dart';

/// Builds the application's `dio` instance.
class ApiClientFactory {
  const ApiClientFactory({
    required this.baseUrl,
    required this.tokenStore,
    this.onUnauthenticated,
  });

  final String baseUrl;
  final TokenStore tokenStore;

  /// Invoked when the API rejects the token, so the session can end
  /// (`FR-SE-19`). Deliberately a callback rather than a direct dependency on
  /// the session: the network layer reports the fact, and does not decide what
  /// to do about it.
  final void Function()? onUnauthenticated;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStore.read();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            onUnauthenticated?.call();
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}

/// Translates a `dio` failure into a [Failure], preserving the API's own
/// message wherever it sent one (`FR-DA-14`).
///
/// The message is only invented where the API said nothing at all — a timeout,
/// a DNS failure — because in those cases there is no API reason to show.
Failure<T> failureFromDioException<T>(DioException exception) {
  final status = exception.response?.statusCode;
  final apiMessage = _messageFromResponse(exception.response?.data);

  final kind = switch (status) {
    400 || 422 => FailureKind.invalidInput,
    401 => FailureKind.unauthenticated,
    403 => FailureKind.forbidden,
    404 => FailureKind.notFound,
    409 => FailureKind.conflict,
    null => FailureKind.unreachable,
    _ => FailureKind.serverError,
  };

  final message =
      apiMessage ??
      switch (exception.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          'The instance did not respond in time.',
        DioExceptionType.connectionError =>
          'The instance could not be reached.',
        _ => 'The request could not be completed.',
      };

  return Failure<T>(message: message, kind: kind);
}

/// Reads the message out of the API's `DataOutput` envelope.
String? _messageFromResponse(Object? data) {
  if (data is! Map) return null;

  final messages = data['messages'];
  if (messages is List && messages.isNotEmpty) {
    final joined = messages.whereType<String>().join(' ');
    if (joined.isNotEmpty) return joined;
  }

  final message = data['message'];
  return message is String && message.isNotEmpty ? message : null;
}
