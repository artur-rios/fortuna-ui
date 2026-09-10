/// The dispatcher on a target with no `dart:ffi` — the web (UC-02).
///
/// Selected by the conditional import in `core_dispatcher.dart`. There is no
/// offline mode on the web (`FR-CF-05`), and `UC-01` never offers it there, so
/// this exists to keep the web build compiling rather than to be reached.
library;

import 'core_dispatcher.dart';

class UnsupportedCoreDispatcher implements CoreDispatcher {
  const UnsupportedCoreDispatcher();

  static const _reason =
      'This build has no FFI boundary, so the Fortuna core cannot be reached '
      'in process. Connect to an instance instead.';

  @override
  Future<CoreResponse> initialize(String requestJson) async =>
      throw const CoreUnavailable(_reason);

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async =>
      throw const CoreUnavailable(_reason);

  @override
  Future<void> dispose() async {}
}

CoreDispatcher platformCoreDispatcher({required String libraryPath}) =>
    const UnsupportedCoreDispatcher();
