/// The core-library probe where `dart:ffi` exists (UC-01, IR-13).
///
/// Selected by the conditional import in `core_library.dart`. This is the only
/// file in the application that opens the core library at setup time; `UC-02`
/// builds the transport on the same library once this has established it loads.
///
/// Loading is how presence is confirmed. A file that exists proves nothing —
/// a wrong architecture, a missing system dependency or a truncated download
/// all produce a library that is right there and will not run, which is exactly
/// what `AF-04` is about.
library;

import 'dart:ffi';
import 'dart:io';

import 'core_library.dart';

/// Searches the places a packaged installation puts the core, and loads it.
class NativeCoreLibraryProbe implements CoreLibraryProbe {
  const NativeCoreLibraryProbe();

  @override
  CoreLibraryAvailability probe() => classifyCoreLibrary(
    platformSupportsOffline: Platform.isWindows || Platform.isLinux,
    locatedAt: locate(),
    open: tryOpen,
  );

  /// Where the core library is, or `null` if it is not in any of the places a
  /// packaged installation puts it.
  ///
  /// Beside the executable first, because that is what the desktop packages
  /// ship (`IR-21`); then the repository's own `native/<os>/`, so a developer
  /// running from source finds a locally built core without installing it.
  static String? locate() {
    final fileName = coreLibraryFileName(isWindows: Platform.isWindows);
    final executableDirectory = File(
      Platform.resolvedExecutable,
    ).parent.absolute.path;

    final candidates = [
      '$executableDirectory${Platform.pathSeparator}$fileName',
      'native${Platform.pathSeparator}'
          '${Platform.isWindows ? 'windows' : 'linux'}'
          '${Platform.pathSeparator}$fileName',
    ];

    for (final candidate in candidates) {
      if (File(candidate).existsSync()) return candidate;
    }
    return null;
  }

  /// Whether the library at [path] actually loads.
  ///
  /// The handle is deliberately discarded: this asks a question, it does not
  /// hand out a library. `UC-02` opens it again for the transport it owns.
  static bool tryOpen(String path) {
    try {
      DynamicLibrary.open(path);
      return true;
    } on Object {
      // Any failure to load is a failure to load. The reason is a platform
      // string that varies by OS and helps nobody here; what matters is that
      // offline mode cannot be offered (AF-04).
      return false;
    }
  }
}

/// The probe for a native target.
CoreLibraryProbe platformCoreLibraryProbe() => const NativeCoreLibraryProbe();
