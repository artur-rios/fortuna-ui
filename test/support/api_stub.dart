/// A `dio` that answers from memory and remembers what it was sent, for the
/// tests of the HTTP repositories (Testing Specification Document, §6.2: "the
/// `HttpClientAdapter` replaced by a local adapter answering from memory").
///
/// No test reaches the network: every request is answered by [ApiStub.answer],
/// and a test that wants the instance unreachable makes the answer throw with
/// [ApiStub.unreachable].
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// What the stub answers a request with.
typedef StubAnswer = ResponseBody Function(RequestOptions request);

/// The base address every stubbed client is built on.
const stubBaseUrl = 'https://fortuna.example';

class ApiStub implements HttpClientAdapter {
  /// Answers every request with [answer]; by default an empty 204.
  ApiStub([StubAnswer? answer]) : answer = answer ?? ((_) => noContent());

  /// Answers every request with [status] and [body] encoded as JSON.
  ApiStub.json(int status, Object? body) : this((_) => json(status, body));

  /// Answers every request with the API's envelope around [data]: what a
  /// successful `DataOutput` looks like on the wire.
  ApiStub.data(Object? data, {int status = 200, List<String>? messages})
    : this((_) => json(status, envelope(data, messages: messages)));

  /// Fails every request as an instance that cannot be reached does.
  ApiStub.unreachable() : this(unreachable);

  StubAnswer answer;

  /// Every request the stub was sent, oldest first.
  final List<RequestOptions> requests = [];

  /// A `dio` whose requests go to this stub.
  late final Dio dio = Dio(BaseOptions(baseUrl: stubBaseUrl))
    ..httpClientAdapter = this;

  /// The one request the stub was sent; fails when there was not exactly one.
  RequestOptions get request {
    if (requests.length != 1) {
      throw StateError('Expected one request, got ${requests.length}.');
    }
    return requests.single;
  }

  /// The body of the one request, as the generated client handed it to `dio`.
  Object? get body => request.data;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return answer(options);
  }

  @override
  void close({bool force = false}) {}
}

/// [status] with [body] encoded as JSON; no body at all when [body] is null.
ResponseBody json(int status, Object? body) => ResponseBody.fromString(
  body == null ? '' : jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

/// The API's `DataOutput` envelope around [data].
Map<String, Object?> envelope(Object? data, {List<String>? messages}) => {
  'success': true,
  'data': data,
  'messages': messages ?? const <String>[],
  'errors': const <String>[],
};

/// A refusal in the API's envelope: [status] with [errors] as its reasons.
ResponseBody refusal(int status, List<String> errors) => json(status, {
  'success': false,
  'data': null,
  'messages': const <String>[],
  'errors': errors,
});

/// An empty 204.
ResponseBody noContent() => ResponseBody.fromString('', 204);

/// [bytes] as a download of [contentType], with the file name the API gives
/// it in `Content-Disposition` when [fileName] is set.
ResponseBody download(
  List<int> bytes, {
  String contentType = 'application/octet-stream',
  String? fileName,
}) => ResponseBody.fromBytes(
  bytes,
  200,
  headers: {
    Headers.contentTypeHeader: [contentType],
    if (fileName != null)
      'content-disposition': ['attachment; filename="$fileName"'],
  },
);

/// Throws what `dio` throws for an instance that cannot be reached.
ResponseBody unreachable(RequestOptions request) => throw DioException(
  requestOptions: request,
  type: DioExceptionType.connectionError,
  message: 'Connection refused',
);
