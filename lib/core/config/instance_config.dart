/// Which instance this installation talks to, and in which mode (FR-CF-02 …
/// FR-CF-05).
///
/// Resolved from the build-time [AppConfig] and, where the user has set one, a
/// stored address that overrides it. The screen that lets them set it is
/// `UC-01`; this is the state it reads and writes.
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

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

/// The resolved instance and mode.
@immutable
class InstanceConfig {
  const InstanceConfig({
    required this.address,
    required this.mode,
    required this.offlineAvailable,
  });

  /// Where the API is. Empty in desktop offline mode, and empty before the user
  /// has chosen an instance.
  final String address;

  final AppMode mode;

  /// Whether desktop offline mode can be offered at all (`FR-CF-04`,
  /// `FR-CF-05`).
  final bool offlineAvailable;

  /// Whether the application has somewhere to send requests. False sends the
  /// user to the setup screen rather than failing later (`UC-01`).
  bool get isResolved => mode == AppMode.desktopOffline || address.isNotEmpty;

  InstanceConfig copyWith({String? address, AppMode? mode}) => InstanceConfig(
    address: address ?? this.address,
    mode: mode ?? this.mode,
    offlineAvailable: offlineAvailable,
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
    return InstanceConfig(
      address: config.apiBaseUrl,
      mode: config.isOffline ? AppMode.desktopOffline : AppMode.connected,
      offlineAvailable: config.isOffline && supportsOfflineMode,
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
  /// The address is validated by the caller before it gets here — an address
  /// is never persisted before it is known to be well-formed (`AF-01`).
  Future<void> useInstance(String address) async {
    await ref
        .read(preferencesStoreProvider)
        .write(PreferenceKey.instanceAddress, address);
    state = state.copyWith(address: address, mode: AppMode.selfHosted);
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
