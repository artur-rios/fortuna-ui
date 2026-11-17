/// The configured HTTP client (IR-08, FR-DA-12).
///
/// One `dio` instance, shared by every generated client, carrying the base
/// address, the timeouts and the bearer-token interceptor. The token is
/// attached to the `Authorization` header and **never** placed in a URL, where
/// it would reach logs, history and referrers.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bindings/core_dispatcher.dart';
import '../config/instance_config.dart';
import '../result/result.dart';
import '../session/session.dart';
import '../session/session_controller.dart';
import '../storage/token_store.dart';
import 'date_only_fields.dart';
import 'explicit_nulls.dart';
import 'ffi_transport.dart';

/// Routes a caller reaches without a session (`UC-03`, `UC-04`, `UC-05`, `UC-09`,
/// `UC-47`). A 401 from one of them is the API refusing what was submitted — a
/// password, a code, a confirmation — never the API rejecting a session token,
/// so it must not end the session (`FR-SE-19` is about the latter).
///
/// Matched against `RequestOptions.path`, which is the route as the generated
/// clients write it (`/api/auth/login`), relative to the base address.
const anonymousAuthPaths = <String>{
  '/api/auth/login',
  '/api/auth/google',
  '/api/auth/2fa/verify',
  '/api/auth/2fa/challenge/resend',
  '/api/auth/password-recovery',
  '/api/auth/password-reset',
  '/api/auth/verify-email',
  '/api/auth/register',
};

/// Builds the application's `dio` instance.
class ApiClientFactory {
  const ApiClientFactory({
    required this.baseUrl,
    required this.tokenStore,
    this.onUnauthenticated,
    this.offlineDispatcher,
  });

  final String baseUrl;
  final TokenStore tokenStore;

  /// Set in desktop offline mode. When present, requests go to the in-process
  /// core instead of the network — the same `dio`, a different way out of it
  /// (`UC-02`, `FR-DA-02`).
  final CoreDispatcher? offlineDispatcher;

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

    final dispatcher = offlineDispatcher;
    if (dispatcher != null) {
      dio.httpClientAdapter = FfiHttpClientAdapter(dispatcher);
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStore.read();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          // A success with no body (a 204, or a 200 with nothing in it) to a
          // call that reads the API's envelope: the generated client would
          // fail on the missing map with a TypeError no repository catches.
          // It reads instead as an envelope with no data, which every
          // repository already answers.
          final body = response.data;
          if (response.requestOptions.responseType == ResponseType.json &&
              (body == null || body == '')) {
            response.data = <String, Object?>{};
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final anonymous = anonymousAuthPaths.contains(
            error.requestOptions.path,
          );
          if (error.response?.statusCode == 401 && !anonymous) {
            onUnauthenticated?.call();
          }
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(const RequestBodyInterceptor());

    return dio;
  }
}

/// Puts every request body into the contract's shape, on either transport:
/// calendar dates as `yyyy-MM-dd` (see date_only_fields.dart) and the
/// explicit nulls of an update (see explicit_nulls.dart).
class RequestBodyInterceptor extends Interceptor {
  const RequestBodyInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.data is Map || options.data is List) {
      options.data = withExplicitNulls(
        options.method,
        options.path,
        normalizeDateOnlyFields(options.data),
      );
    }
    handler.next(options);
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
    // The offline core's FORTUNA_STATUS_NOT_IMPLEMENTED, and the adapter's own
    // refusal of a route the core does not export. The API itself never
    // answers 501, so over HTTP this changes nothing.
    501 => FailureKind.unavailableOffline,
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

/// Translates an answer the generated client could not read into a
/// [Failure] (`UC-02 AF-07`).
///
/// The generated client decodes strictly: a key the contract does not declare
/// (every DTO is `additionalProperties: false`), a null where a value is
/// required, or a value of the wrong type fails the parse — with a
/// `BadKeyException`, a `TypeError`, an `ArgumentError` or a
/// `FormatException`, never a `DioException`. Such an answer fails the way a
/// body that is not JSON at all already does: dio reports that as an
/// `unknown` [DioException] with no response, so this is that failure.
Failure<T> failureFromUnreadableAnswer<T>(Object error) =>
    failureFromDioException<T>(
      DioException(requestOptions: RequestOptions(), error: error),
    );

/// Reads the reason out of the API's `DataOutput` envelope.
///
/// A refusal's reasons travel in `errors` — that is where both the API and the
/// offline core put them, and what the envelope's `success` is computed from.
/// `messages` carries informational text and is only a fallback, for an answer
/// that failed without stating an error.
String? _messageFromResponse(Object? body) {
  final data = _decodedBody(body);
  if (data is! Map) return null;

  for (final key in const ['errors', 'messages']) {
    final entries = data[key];
    if (entries is List && entries.isNotEmpty) {
      final joined = entries
          .whereType<String>()
          .where((entry) => entry.trim().isNotEmpty)
          .join(' ');
      if (joined.isNotEmpty) return joined;
    }
  }

  final message = data['message'];
  return message is String && message.isNotEmpty ? message : null;
}

/// The body of a failed answer as JSON, where it arrived undecoded.
///
/// A download asks for `ResponseType.bytes`, and `dio` hands a refusal's body
/// back the same way, so the envelope with the API's reason is still bytes
/// here. Anything that is not JSON is no reason to show.
Object? _decodedBody(Object? body) {
  final text = switch (body) {
    final List<int> bytes => utf8.decode(bytes, allowMalformed: true),
    final String text => text,
    _ => null,
  };
  if (text == null) return body;

  try {
    return jsonDecode(text);
  } on FormatException {
    return null;
  }
}

/// The core dispatcher, in desktop offline mode only (`UC-02`).
///
/// `null` on every other transport, which is what makes the offline branch in
/// [dioProvider] a single question rather than a mode flag threaded everywhere.
final coreDispatcherProvider = Provider<CoreDispatcher?>((ref) {
  final instance = ref.watch(instanceConfigProvider);
  if (instance.mode != AppMode.desktopOffline) return null;

  final path = ref.watch(coreLibraryProbeProvider).libraryPath;
  if (path == null) return null;

  final config = ref.watch(appConfigProvider);
  final dispatcher = InitializingCoreDispatcher(
    createCoreDispatcher(libraryPath: path),
    configurationJson: jsonEncode({
      // Empty means "beside the executable", which is what makes the portable
      // package portable (AppConfig.databasePath).
      'databasePath': config.databasePath,
      'localAuthEnabled': true,
      'tokenLifetimeSeconds': 3600,
    }),
  );

  ref.onDispose(() => unawaited(dispatcher.dispose()));
  return dispatcher;
});

/// The application's shared `dio` instance (IR-08).
///
/// Derived from the resolved instance rather than wired by hand at start-up, so
/// that pointing the application at a different instance rebuilds the client
/// that talks to it, with no step for anyone to forget.
final dioProvider = Provider<Dio>((ref) {
  final instance = ref.watch(instanceConfigProvider);
  final dispatcher = ref.watch(coreDispatcherProvider);

  return ApiClientFactory(
    // In offline mode nothing is ever sent anywhere, but `dio` still requires a
    // base against which to resolve a path. This one names the transport rather
    // than a host, so a request that somehow escaped would fail visibly instead
    // of reaching a real address.
    baseUrl: dispatcher != null ? 'core://fortuna/' : instance.address,
    tokenStore: ref.watch(tokenStoreProvider),
    offlineDispatcher: dispatcher,
    // FR-SE-19: a rejected token ends the session. No silent refresh, and no
    // replay of whatever was interrupted (FR-SE-20).
    onUnauthenticated: () =>
        unawaited(ref.read(sessionProvider.notifier).rejectedByApi()),
  ).create();
});
