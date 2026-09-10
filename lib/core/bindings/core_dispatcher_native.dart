/// The FFI boundary itself (UC-02, IR-13, FR-DA-08, FR-DA-09).
///
/// Every call to the core happens on a worker isolate. The UI isolate sends a
/// symbol and a JSON request and awaits a reply; it never opens the library,
/// never holds a pointer, and is never blocked by SQLite doing work.
///
/// Two rules govern the code below, and both are about memory the core owns:
///
///  - **Every response string is released exactly once**, including when
///    decoding it throws and including when the call failed (`FR-DA-09`). That
///    is why the free sits in a `finally` around the decode rather than after
///    it.
///  - **Every pointer this side allocates is freed on every path**, which is
///    what the outer `finally` is for.
library;

import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'core_dispatcher.dart';
import 'fortuna_bindings.dart';

/// Every routed export shares one signature, so one typed lookup serves all 113
/// of them rather than a switch over generated methods.
typedef _OperationNative = Int Function(
  Pointer<Char> request,
  Pointer<Pointer<Char>> response,
);
typedef _OperationDart = int Function(
  Pointer<Char> request,
  Pointer<Pointer<Char>> response,
);

/// What the worker is being asked to do.
enum _Op { initialize, call, shutdown }

class _Request {
  const _Request(this.op, this.symbol, this.json, this.reply);

  final _Op op;
  final String symbol;
  final String json;
  final SendPort reply;
}

class _Reply {
  const _Reply({this.status = 0, this.body = '', this.error});

  final int status;
  final String body;
  final String? error;
}

/// Runs the core on a worker isolate.
class IsolateCoreDispatcher implements CoreDispatcher {
  IsolateCoreDispatcher({required this.libraryPath});

  final String libraryPath;

  Isolate? _isolate;
  SendPort? _worker;
  Future<void>? _starting;
  var _disposed = false;

  Future<void> _ensureStarted() {
    if (_disposed) {
      throw const CoreUnavailable('The core has already been shut down.');
    }
    return _starting ??= _start();
  }

  Future<void> _start() async {
    final ready = ReceivePort();
    final failure = ReceivePort();

    try {
      _isolate = await Isolate.spawn(
        _workerMain,
        _WorkerConfig(libraryPath, ready.sendPort),
        onError: failure.sendPort,
        errorsAreFatal: true,
      );
    } on Object catch (error) {
      ready.close();
      failure.close();
      throw CoreUnavailable('The core worker could not be started: $error.');
    }

    // The worker reports either the port to talk to it on, or why it could not
    // open the library. A library that will not load must surface here rather
    // than as a hang on the first call.
    final first = await ready.first;
    ready.close();
    failure.close();

    if (first is String) {
      throw CoreUnavailable(first);
    }
    _worker = first as SendPort;
  }

  Future<CoreResponse> _send(_Op op, String symbol, String json) async {
    await _ensureStarted();

    final reply = ReceivePort();
    _worker!.send(_Request(op, symbol, json, reply.sendPort));

    final result = await reply.first as _Reply;
    reply.close();

    final error = result.error;
    if (error != null) throw CoreUnavailable(error);

    return CoreResponse(status: result.status, body: result.body);
  }

  @override
  Future<CoreResponse> initialize(String requestJson) =>
      _send(_Op.initialize, '', requestJson);

  @override
  Future<CoreResponse> call(String symbol, String requestJson) =>
      _send(_Op.call, symbol, requestJson);

  @override
  Future<void> dispose() async {
    if (_disposed) return;

    // Shut the core down before killing the isolate, so SQLite closes cleanly
    // and in-memory sessions are invalidated rather than abandoned.
    if (_worker != null) {
      try {
        await _send(_Op.shutdown, '', '{}');
      } on Object {
        // A core that will not shut down cleanly still must not keep the
        // isolate alive; the kill below is the backstop.
      }
    }

    _disposed = true;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _worker = null;
  }
}

class _WorkerConfig {
  const _WorkerConfig(this.libraryPath, this.ready);

  final String libraryPath;
  final SendPort ready;
}

/// The worker. Opens the library once, then serves requests until killed.
void _workerMain(_WorkerConfig config) {
  final FortunaBindings bindings;
  final DynamicLibrary library;

  try {
    library = DynamicLibrary.open(config.libraryPath);
    bindings = FortunaBindings(library);
  } on Object catch (error) {
    config.ready.send(
      'The Fortuna core at ${config.libraryPath} could not be loaded: $error.',
    );
    return;
  }

  final inbox = ReceivePort();
  config.ready.send(inbox.sendPort);

  inbox.listen((message) {
    final request = message as _Request;

    try {
      final reply = switch (request.op) {
        _Op.initialize => _invoke(
          bindings.fortuna_initialize,
          bindings,
          request.json,
        ),
        _Op.shutdown => _invoke(
          bindings.fortuna_shutdown,
          bindings,
          request.json,
        ),
        _Op.call => _invoke(
          library.lookupFunction<_OperationNative, _OperationDart>(
            request.symbol,
          ),
          bindings,
          request.json,
        ),
      };
      request.reply.send(reply);
    } on Object catch (error) {
      // An unknown symbol, or anything else that went wrong crossing the
      // boundary. Reported as a value; no exception escapes the data layer.
      request.reply.send(_Reply(error: 'The core call failed: $error.'));
    }
  });
}

/// Calls one operation, and releases everything either side allocated.
_Reply _invoke(
  _OperationDart operation,
  FortunaBindings bindings,
  String json,
) {
  final request = json.toNativeUtf8();
  final response = calloc<Pointer<Char>>();

  try {
    final status = operation(request.cast<Char>(), response);
    final returned = response.value;

    if (returned == nullptr) {
      return _Reply(status: status);
    }

    try {
      return _Reply(status: status, body: returned.cast<Utf8>().toDartString());
    } finally {
      // FR-DA-09. In a `finally` so that a body which fails to decode is still
      // released — the leak that would otherwise happen only on the error path
      // is exactly the one nobody notices.
      bindings.fortuna_string_free(returned);
    }
  } finally {
    calloc
      ..free(request)
      ..free(response);
  }
}

/// The dispatcher for a native target.
CoreDispatcher platformCoreDispatcher({required String libraryPath}) =>
    IsolateCoreDispatcher(libraryPath: libraryPath);
