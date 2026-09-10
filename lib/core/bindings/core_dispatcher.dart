/// The seam between the application and the core's C ABI (UC-02, FR-DA-08).
///
/// Deliberately free of `dart:ffi`. Everything above the bindings layer — the
/// Dio adapter, and through it every repository — talks to this interface, so
/// the transport can be faked in a test without a library on disk and without
/// tripping `IR-13`.
///
/// The implementation that actually crosses the boundary lives in
/// `core_dispatcher_native.dart`, behind a conditional import, because
/// `dart:ffi` does not exist on the web.
library;

import 'package:meta/meta.dart';

import 'core_dispatcher_unsupported.dart'
    if (dart.library.ffi) 'core_dispatcher_native.dart';

/// What the core answered: an HTTP-compatible status and a JSON body.
///
/// The core mirrors the API's own `DataOutput` envelope, which is what lets one
/// set of repositories read both transports (`FR-DA-03`).
@immutable
class CoreResponse {
  const CoreResponse({required this.status, required this.body});

  /// One of the `FORTUNA_STATUS_*` values, which are HTTP status codes.
  final int status;

  /// The response JSON, or empty where the core returned no body.
  final String body;
}

/// Raised when the core cannot be reached at all — the library is missing, will
/// not load, or the worker died.
///
/// Never escapes the data layer: the Dio adapter turns it into a response the
/// repositories render as a [Failure] (`FR-DA-10`, `AF-01`).
class CoreUnavailable implements Exception {
  const CoreUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Carries one operation across the FFI boundary.
abstract interface class CoreDispatcher {
  /// Initializes the core. Safe to call more than once — a second call answers
  /// `409`, which the caller treats as already-initialized.
  Future<CoreResponse> initialize(String requestJson);

  /// Calls [symbol] with [requestJson] and returns what the core answered.
  ///
  /// Every string the core returns is released before this completes, including
  /// where the call failed (`FR-DA-09`).
  Future<CoreResponse> call(String symbol, String requestJson);

  /// Shuts the core down and stops the worker.
  Future<void> dispose();
}

/// Initializes the core exactly once, before the first operation reaches it.
///
/// The core refuses every operation with `503` until `fortuna_initialize` has
/// run, and answers `409` if it runs twice. Both are handled here rather than
/// by every caller: a repository should not have to know the core has a
/// lifecycle, any more than it knows an HTTP client has a connection pool.
class InitializingCoreDispatcher implements CoreDispatcher {
  InitializingCoreDispatcher(this._inner, {required this.configurationJson});

  final CoreDispatcher _inner;

  /// The `{databasePath, localAuthEnabled, tokenLifetimeSeconds}` object the
  /// core is initialized from.
  final String configurationJson;

  Future<void>? _initializing;

  Future<void> _ensureInitialized() => _initializing ??= _initialize();

  Future<void> _initialize() async {
    final response = await _inner.initialize(configurationJson);

    // 409 is "already initialized", which is a success from here: another
    // dispatcher in this process got there first.
    if (response.status >= 400 && response.status != 409) {
      // Cleared so a later call retries rather than being permanently poisoned
      // by one bad start — a database that was locked a moment ago may not be.
      _initializing = null;
      throw CoreUnavailable(
        'The Fortuna core could not be initialized '
        '(${response.status}): ${response.body}',
      );
    }
  }

  @override
  Future<CoreResponse> initialize(String requestJson) =>
      _inner.initialize(requestJson);

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async {
    await _ensureInitialized();
    return _inner.call(symbol, requestJson);
  }

  @override
  Future<void> dispose() => _inner.dispose();
}

/// The dispatcher for this platform, over the library at [libraryPath].
///
/// Resolves to the isolate-backed `dart:ffi` implementation where there is one,
/// and to one that refuses on the web.
CoreDispatcher createCoreDispatcher({required String libraryPath}) =>
    platformCoreDispatcher(libraryPath: libraryPath);
