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
import 'ffi_transport.dart';

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
