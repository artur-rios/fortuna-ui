/// Which instance this installation talks to, and in which mode (FR-CF-02 …
/// FR-CF-05).
///
/// Resolved from the build-time [AppConfig], what the installation carries, and
/// — where the user has set one — a stored address that overrides the build's.
/// The screen that lets them set it is `UC-01`; this is the state it reads and
/// writes.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../bindings/core_library.dart';
import '../session/session.dart';
import '../storage/preferences_store.dart';
import 'app_config.dart';

/// Supplies the build-time configuration. Overridden in tests.
final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

/// Supplies the preferences store. Overridden at start-up and in tests.
final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => throw UnimplementedError(
    'preferencesStoreProvider must be overridden at start-up',
  ),
);

/// Answers whether this installation carries a loadable core (`UC-01` step 2).
///
/// A provider rather than a direct call so that tests, and a build that should
/// not go looking, can answer it without a file system.
final coreLibraryProbeProvider = Provider<CoreLibraryProbe>(
  (ref) => defaultCoreLibraryProbe(),
);

/// The resolved instance and mode.
@immutable
class InstanceConfig {
  const InstanceConfig({
    required this.address,
    required this.mode,
    required this.coreLibrary,
  });

  /// Where the API is. Empty in desktop offline mode, and empty before the user
  /// has chosen an instance.
  final String address;

  final AppMode mode;

  /// What this installation carries, which is what decides whether offline mode
  /// can be offered at all (`FR-CF-04`, `FR-CF-05`).
  final CoreLibraryAvailability coreLibrary;

  /// Whether desktop offline mode can be offered (`AF-03`).
  bool get offlineAvailable => coreLibrary.canRunOffline;

  /// Whether the installation meant to run offline and cannot (`AF-04`).
  bool get offlineFailed => coreLibrary.isFailure;

  /// Whether the application has somewhere to send requests. False sends the
  /// user to the setup screen rather than failing later (`UC-01`).
  bool get isResolved => mode == AppMode.desktopOffline || address.isNotEmpty;

  InstanceConfig copyWith({String? address, AppMode? mode}) => InstanceConfig(
    address: address ?? this.address,
    mode: mode ?? this.mode,
    coreLibrary: coreLibrary,
  );
}

final instanceConfigProvider =
    NotifierProvider<InstanceConfigController, InstanceConfig>(
      InstanceConfigController.new,
    );

class InstanceConfigController extends Notifier<InstanceConfig> {
  @override
  InstanceConfig build() {
    final config = ref.watch(appConfigProvider);
    final coreLibrary = ref.watch(coreLibraryProbeProvider).probe();

    // AF-04: a build wired for offline mode whose core will not load does not
    // start in offline mode. It falls back to the connected shape, which sends
    // the user to setup, where the failure is reported and the connected paths
    // are offered — rather than into an application whose every request would
    // cross a boundary that is not there.
    final runsOffline = config.isOffline && coreLibrary.canRunOffline;

    return InstanceConfig(
      address: runsOffline ? '' : config.apiBaseUrl,
      mode: runsOffline ? AppMode.desktopOffline : AppMode.connected,
      coreLibrary: coreLibrary,
    );
  }

  /// Whether this platform can host desktop offline mode at all.
  ///
  /// Windows and Linux only, and never the web or Android — an offline option
  /// that cannot work is worse than no option (`FR-CF-05`).
  static bool get supportsOfflineMode {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux;
  }

  /// Loads a previously stored address, if the user set one.
  Future<void> restore() async {
    if (state.mode == AppMode.desktopOffline) return;

    final stored = await ref
        .read(preferencesStoreProvider)
        .read(PreferenceKey.instanceAddress);

    if (stored != null && stored.isNotEmpty) {
      state = state.copyWith(address: stored, mode: AppMode.selfHosted);
    }
  }

  /// Records the instance the user chose (`UC-01`).
  ///
  /// The address is validated **and probed** by the caller before it gets here.
  /// Nothing is persisted until an instance has answered and said it speaks a
  /// contract this build understands — `AF-02` requires that a bad address
  /// leave no trace to come back to on the next start.
  Future<void> useInstance(String address) async {
    await ref
        .read(preferencesStoreProvider)
        .write(PreferenceKey.instanceAddress, address);
    state = state.copyWith(address: address, mode: AppMode.selfHosted);
  }

  /// Switches this installation to desktop offline mode (`UC-01` step 6).
  ///
  /// Refuses where the core cannot run, so that the mode can never be entered
  /// by a caller that skipped the check (`AF-03`, `AF-04`).
  bool useOfflineMode() {
    if (!state.offlineAvailable) return false;

    state = InstanceConfig(
      address: '',
      mode: AppMode.desktopOffline,
      coreLibrary: state.coreLibrary,
    );
    return true;
  }

  /// Whether [address] is a well-formed absolute http(s) URL (`FR-CF-02`).
  static bool isWellFormedAddress(String address) {
    final uri = Uri.tryParse(address.trim());
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
