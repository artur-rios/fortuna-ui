/// Whether this installation carries a loadable Fortuna core (UC-01, IR-13).
///
/// Step 2 of `UC-01`'s main flow asks a narrow question — *can this
/// installation run desktop offline mode at all?* — and three of its
/// alternative flows turn on the answer. The question is answered here rather
/// than in the setup screen because answering it needs `dart:ffi`, which
/// `IR-13` confines to this directory.
///
/// This is deliberately **only** the probe. Binding the core's operations is
/// `UC-02`, which builds the transport on top of the library this file has
/// established is there.
///
/// The actual `dlopen` lives behind a conditional import: `dart:ffi` does not
/// exist on the web, so importing it unconditionally would break the web build
/// of an application that offers no offline mode there anyway (`FR-CF-05`).
library;

import 'package:meta/meta.dart';

import 'core_library_unsupported.dart'
    if (dart.library.ffi) 'core_library_native.dart';

/// What this installation can do about desktop offline mode.
enum CoreLibraryAvailability {
  /// The web, or Android. Offline mode is not offered at all (`FR-CF-05`,
  /// `AF-03`).
  unsupportedPlatform,

  /// A desktop installation that simply does not ship the core (`AF-03`).
  absent,

  /// The core is there and will not load — a wrong architecture, a missing
  /// system dependency, a corrupt file.
  ///
  /// Distinct from [absent] because the two say different things to a user:
  /// one installation was never meant to work offline, the other was and
  /// cannot (`AF-04`).
  failedToLoad,

  /// Present, loadable, and offline mode can be offered.
  available;

  /// Whether desktop offline mode may be offered on the strength of this.
  bool get canRunOffline => this == CoreLibraryAvailability.available;

  /// Whether the user should be told something went wrong.
  ///
  /// Only [failedToLoad]. An installation that never carried the core has
  /// nothing to apologize for, and saying so would advertise a mode that was
  /// never on offer.
  bool get isFailure => this == CoreLibraryAvailability.failedToLoad;
}

/// The core library's file name on [isWindows].
///
/// The name matches what `fortuna-api` publishes — it builds `fortuna_core`,
/// so that is what this side looks for. Vendoring is `UC-02`'s job; agreeing on
/// the name is this one's, because the probe cannot look for a file nobody has
/// named.
String coreLibraryFileName({required bool isWindows}) =>
    isWindows ? 'fortuna_core.dll' : 'libfortuna_core.so';

/// Classifies an installation from facts about it, without touching the
/// platform.
///
/// Pulled out as a pure function so every branch — including the two that need
/// a broken library to reproduce — is reachable from a unit test.
///
/// [locatedAt] is the path the library was found at, or `null` when the search
/// found nothing. [open] attempts to load it and reports whether that worked.
CoreLibraryAvailability classifyCoreLibrary({
  required bool platformSupportsOffline,
  required String? locatedAt,
  required bool Function(String path) open,
}) {
  if (!platformSupportsOffline) {
    return CoreLibraryAvailability.unsupportedPlatform;
  }
  if (locatedAt == null || locatedAt.isEmpty) {
    return CoreLibraryAvailability.absent;
  }
  return open(locatedAt)
      ? CoreLibraryAvailability.available
      : CoreLibraryAvailability.failedToLoad;
}

/// Reports what this installation carries.
abstract interface class CoreLibraryProbe {
  CoreLibraryAvailability probe();

  /// Where the library was found, or `null` when there is none to open.
  ///
  /// The transport needs the path the probe already resolved; making it look
  /// again would be a second search that could disagree with the first.
  String? get libraryPath;
}

/// A probe that reports whatever it was told to. For tests, and for overriding
/// the answer in a build that should not go looking.
@immutable
class FixedCoreLibraryProbe implements CoreLibraryProbe {
  const FixedCoreLibraryProbe(this._availability, {this.libraryPath});

  final CoreLibraryAvailability _availability;

  @override
  final String? libraryPath;

  @override
  CoreLibraryAvailability probe() => _availability;
}

/// The probe for the platform this build runs on.
///
/// Resolves to the `dart:ffi` implementation where there is one, and to a
/// permanently-unsupported answer on the web.
CoreLibraryProbe defaultCoreLibraryProbe() => platformCoreLibraryProbe();
