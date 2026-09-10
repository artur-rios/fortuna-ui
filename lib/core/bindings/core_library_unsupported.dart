/// The core-library probe on a target with no `dart:ffi` — the web (UC-01).
///
/// Selected by the conditional import in `core_library.dart`. There is no
/// offline mode on the web at all (`FR-CF-05`), so the answer is a constant
/// rather than a search that could not succeed.
library;

import 'core_library.dart';

/// Always reports [CoreLibraryAvailability.unsupportedPlatform], and never a
/// path — there is nothing here to open.
CoreLibraryProbe platformCoreLibraryProbe() =>
    const FixedCoreLibraryProbe(CoreLibraryAvailability.unsupportedPlatform);
