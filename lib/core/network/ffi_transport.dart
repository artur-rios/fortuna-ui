/// Desktop offline mode, as a `dio` adapter (UC-02, FR-DA-01, FR-DA-02).
///
/// The core mirrors the API's routes and answers in the API's own `DataOutput`
/// envelope, so the cheapest correct way to make the two transports
/// interchangeable is to swap what `dio` sends the request *through* — not to
/// write a second implementation of every repository.
///
/// That is what this is. Every repository in the application already takes the
/// shared `Dio`; in offline mode that `Dio` carries this adapter, and the
/// repositories are unchanged and unaware. `FR-DA-03` — identical behavior for
/// the same input on either transport — stops being something to test for in
/// twelve places and becomes structural.
///
/// No `dart:ffi` here: the boundary is behind [CoreDispatcher] (`IR-13`).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../bindings/core_dispatcher.dart';
import '../bindings/core_route.dart';

/// Routes `dio` requests to the in-process core instead of the network.
class FfiHttpClientAdapter implements HttpClientAdapter {
  FfiHttpClientAdapter(this._dispatcher);

  final CoreDispatcher _dispatcher;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final resolved = resolveCoreRoute(options.method, options.path);

    // The core deliberately exports no Heimdall auth, no Pluggy connection and
    // no hosted consent route. Saying so plainly is far better than a crash, or
    // than a silent empty answer that would read as "you have none of these".
    if (resolved == null) {
      return _json(
        501,
        'This is not available offline: '
        '${options.method.toUpperCase()} ${options.path}.',
      );
    }

    try {
      final response = await _dispatcher.call(
        resolved.symbol,
        jsonEncode(buildCoreRequest(options, resolved)),
      );

      return ResponseBody.fromString(
        response.body,
        response.status,
        headers: _jsonHeaders,
      );
    } on CoreUnavailable catch (error) {
      // AF-01. Returned as a response rather than thrown, so it reaches the
      // repositories the same way an HTTP failure does and becomes a Failure
      // value there — no exception escapes the data layer (FR-DA-10).
      return _json(503, error.message);
    }
  }

  @override
  void close({bool force = false}) {}
}

/// Builds the `{token, route, query, body}` envelope the core expects.
///
/// Kept a free function so the mapping is testable on its own: this is where a
/// request stops being an HTTP request and becomes a core call, and getting it
/// wrong is silent.
Map<String, Object?> buildCoreRequest(
  RequestOptions options,
  ResolvedRoute resolved,
) {
  final envelope = <String, Object?>{
    'token': _bearerToken(options.headers),
    'route': resolved.values,
    'query': {
      for (final entry in options.queryParameters.entries)
        if (entry.value != null) entry.key: _queryValue(entry.value),
    },
  };

  final body = options.data;
  if (body != null) {
    // The body travels unchanged — it is already the JSON the API would have
    // received, decimals included, and re-encoding it through anything numeric
    // is precisely how BR-05 gets broken (FR-DA-11).
    envelope['body'] = body is String ? jsonDecode(body) : body;
  }

  return envelope;
}

/// The bearer token, without the scheme, or an empty string when there is none.
///
/// The core wants the token itself; `dio` carries it as `Bearer <token>`.
String _bearerToken(Map<String, dynamic> headers) {
  final header = headers['Authorization'] ?? headers['authorization'];
  if (header is! String || header.isEmpty) return '';

  const prefix = 'Bearer ';
  return header.startsWith(prefix) ? header.substring(prefix.length) : header;
}

/// Query values reach the core as JSON, so a list stays a list and everything
/// else travels as the string the API would have parsed from the query string.
Object? _queryValue(Object? value) => switch (value) {
  Iterable<Object?>() => [for (final item in value) item.toString()],
  bool() || num() => value,
  _ => value.toString(),
};

const _jsonHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

/// A failure shaped like the API's own envelope, so the repositories read its
/// reason exactly as they read the API's (`FR-DA-14`).
ResponseBody _json(int status, String message) => ResponseBody.fromString(
  jsonEncode({
    'data': null,
    'success': false,
    'messages': [message],
  }),
  status,
  headers: _jsonHeaders,
);
