import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/setup/data/instance_probe.dart';
import 'package:fortuna_ui/features/setup/state/setup_controller.dart';

/// Answers whatever the test told it to, and records what it was asked.
class FakeProbe implements InstanceProbe {
  FakeProbe(this.answer);

  Result<InstanceIdentity> Function(String address) answer;
  final List<String> probed = [];

  @override
  Future<Result<InstanceIdentity>> probe(String address) async {
    probed.add(address);
    return answer(address);
  }
}

Result<InstanceIdentity> reachable({String? version = 'v1'}) =>
    Success(InstanceIdentity(contractVersion: version, service: 'Fortuna API'));

Result<InstanceIdentity> unreachable([String message = 'No answer.']) =>
    Failure<InstanceIdentity>(message: message, kind: FailureKind.unreachable);

ProviderContainer containerWith({
  required FakeProbe probe,
  CoreLibraryAvailability core = CoreLibraryAvailability.unsupportedPlatform,
  PreferencesStore? preferences,
  AppConfig config = const AppConfig(
    apiBaseUrl: '',
    googleClientId: '',
    transport: Transport.http,
    databasePath: '',
  ),
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      preferencesStoreProvider.overrideWithValue(
        preferences ?? InMemoryPreferencesStore(),
      ),
      coreLibraryProbeProvider.overrideWithValue(FixedCoreLibraryProbe(core)),
      instanceProbeProvider.overrideWithValue(probe),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SetupController.useAddress', () {
    test(
      'Given a malformed address '
      'When it is submitted '
      'Then it is rejected and no request is attempted (UC-01 AF-01)',
      () async {
        final probe = FakeProbe((_) => reachable());
        final container = containerWith(probe: probe);

        await container
            .read(setupControllerProvider.notifier)
            .useAddress('fortuna.example');

        expect(container.read(setupControllerProvider), isA<SetupRejected>());
        expect(probe.probed, isEmpty);
      },
    );

    test('Given a malformed address '
        'When it is rejected '
        'Then nothing is persisted (UC-01 AF-01)', () async {
      final preferences = InMemoryPreferencesStore();
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        preferences: preferences,
      );

      await container
          .read(setupControllerProvider.notifier)
          .useAddress('not a url');

      expect(await preferences.read(PreferenceKey.instanceAddress), isNull);
    });

    test('Given a reachable instance speaking the expected contract '
        'When its address is submitted '
        'Then it is persisted and setup completes (UC-01 main flow)', () async {
      final preferences = InMemoryPreferencesStore();
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        preferences: preferences,
      );

      await container
          .read(setupControllerProvider.notifier)
          .useAddress('  https://fortuna.example  ');

      expect(container.read(setupControllerProvider), isA<SetupComplete>());
      // Trimmed before it is stored, so a stray space does not become a
      // different instance on the next start.
      expect(
        await preferences.read(PreferenceKey.instanceAddress),
        'https://fortuna.example',
      );

      final instance = container.read(instanceConfigProvider);
      expect(instance.address, 'https://fortuna.example');
      expect(instance.mode, AppMode.selfHosted);
      expect(instance.isResolved, isTrue);
    });

    test(
      'Given an instance that cannot be reached '
      'When its address is submitted '
      'Then it is reported and the address is not persisted (UC-01 AF-02)',
      () async {
        final preferences = InMemoryPreferencesStore();
        final container = containerWith(
          probe: FakeProbe(
            (_) => unreachable('The instance could not be reached.'),
          ),
          preferences: preferences,
        );

        await container
            .read(setupControllerProvider.notifier)
            .useAddress('https://nowhere.example');

        final state = container.read(setupControllerProvider);
        expect(state, isA<SetupUnreachable>());
        expect(state.message, 'The instance could not be reached.');
        expect(await preferences.read(PreferenceKey.instanceAddress), isNull);
        expect(container.read(instanceConfigProvider).isResolved, isFalse);
      },
    );

    test(
      'Given an instance reporting an incompatible contract '
      'When its address is submitted '
      'Then setup refuses to proceed and names both versions (UC-01 AF-05)',
      () async {
        final preferences = InMemoryPreferencesStore();
        final container = containerWith(
          probe: FakeProbe((_) => reachable(version: 'v9')),
          preferences: preferences,
        );

        await container
            .read(setupControllerProvider.notifier)
            .useAddress('https://fortuna.example');

        final state = container.read(setupControllerProvider);
        expect(state, isA<SetupIncompatible>());
        final incompatible = state as SetupIncompatible;
        expect(incompatible.compatibility.reportedOrUnknown, 'v9');
        expect(incompatible.compatibility.expected, 'v1');

        // Refusing to proceed means exactly that: nothing was pointed at it.
        expect(await preferences.read(PreferenceKey.instanceAddress), isNull);
        expect(container.read(instanceConfigProvider).isResolved, isFalse);
      },
    );

    test(
      'Given an instance that names no contract version at all '
      'When its address is submitted '
      'Then it is refused rather than optimistically accepted (UC-01 AF-05)',
      () async {
        final container = containerWith(
          probe: FakeProbe((_) => reachable(version: null)),
        );

        await container
            .read(setupControllerProvider.notifier)
            .useAddress('https://fortuna.example');

        expect(
          container.read(setupControllerProvider),
          isA<SetupIncompatible>(),
        );
      },
    );

    test('Given a configured instance whose connection is then lost '
        'When it is configured again '
        'Then the loss is reported rather than the earlier success reused '
        '(UC-01 AF-06)', () async {
      var reachableNow = true;
      final probe = FakeProbe(
        (_) => reachableNow ? reachable() : unreachable('Connection lost.'),
      );
      final container = containerWith(probe: probe);
      final controller = container.read(setupControllerProvider.notifier);

      await controller.useAddress('https://fortuna.example');
      expect(container.read(setupControllerProvider), isA<SetupComplete>());

      reachableNow = false;
      await controller.useAddress('https://fortuna.example');

      final state = container.read(setupControllerProvider);
      expect(state, isA<SetupUnreachable>());
      expect(state.message, 'Connection lost.');
      // Asked again rather than answered from what was true a moment ago.
      expect(probe.probed.length, 2);
    });

    test('Given a rejected address '
        'When the user edits the field '
        'Then the rejection clears so the correction is not masked', () async {
      final container = containerWith(probe: FakeProbe((_) => reachable()));
      final controller = container.read(setupControllerProvider.notifier);

      await controller.useAddress('nonsense');
      expect(container.read(setupControllerProvider), isA<SetupRejected>());

      controller.reset();
      expect(container.read(setupControllerProvider), isA<SetupIdle>());
    });
  });

  group('SetupController.useOfflineMode', () {
    test('Given an installation whose core loads '
        'When offline mode is chosen '
        'Then the mode is entered and setup completes (UC-01 main flow)', () {
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.available,
      );

      container.read(setupControllerProvider.notifier).useOfflineMode();

      expect(container.read(setupControllerProvider), isA<SetupComplete>());
      final instance = container.read(instanceConfigProvider);
      expect(instance.mode, AppMode.desktopOffline);
      expect(instance.isResolved, isTrue);
      expect(instance.address, isEmpty);
    });

    test('Given a core library that is present and will not load '
        'When offline mode is chosen '
        'Then it is reported unavailable and the mode is not entered '
        '(UC-01 AF-04)', () {
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.failedToLoad,
      );

      container.read(setupControllerProvider.notifier).useOfflineMode();

      final state = container.read(setupControllerProvider);
      expect(state, isA<SetupOfflineUnavailable>());
      expect(state.message, contains('could not be loaded'));
      expect(
        container.read(instanceConfigProvider).mode,
        isNot(AppMode.desktopOffline),
      );
    });

    test('Given a platform that cannot host offline mode '
        'When offline mode is chosen anyway '
        'Then it is refused rather than entered (UC-01 AF-03)', () {
      for (final core in [
        CoreLibraryAvailability.unsupportedPlatform,
        CoreLibraryAvailability.absent,
      ]) {
        final container = containerWith(
          probe: FakeProbe((_) => reachable()),
          core: core,
        );

        container.read(setupControllerProvider.notifier).useOfflineMode();

        expect(
          container.read(setupControllerProvider),
          isA<SetupOfflineUnavailable>(),
          reason: '$core should not enter offline mode',
        );
        expect(
          container.read(instanceConfigProvider).mode,
          isNot(AppMode.desktopOffline),
        );
      }
    });
  });

  group('InstanceConfig from the build and the installation', () {
    test('Given a build wired for offline mode whose core will not load '
        'When the instance is resolved '
        'Then it falls back to the connected shape (UC-01 AF-04)', () {
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.failedToLoad,
        config: const AppConfig(
          apiBaseUrl: '',
          googleClientId: '',
          transport: Transport.ffi,
          databasePath: '',
        ),
      );

      final instance = container.read(instanceConfigProvider);

      expect(instance.mode, AppMode.connected);
      expect(instance.offlineAvailable, isFalse);
      expect(instance.offlineFailed, isTrue);
      // Unresolved, so the guard sends the user to setup, where AF-04 is shown.
      expect(instance.isResolved, isFalse);
    });

    test('Given a build wired for offline mode whose core loads '
        'When the instance is resolved '
        'Then it starts in desktop offline mode with no address', () {
      final container = containerWith(
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.available,
        config: const AppConfig(
          apiBaseUrl: 'https://ignored.example',
          googleClientId: '',
          transport: Transport.ffi,
          databasePath: '',
        ),
      );

      final instance = container.read(instanceConfigProvider);

      expect(instance.mode, AppMode.desktopOffline);
      expect(instance.address, isEmpty);
      expect(instance.isResolved, isTrue);
    });

    test(
      'Given a build naming a default instance '
      'When the instance is resolved '
      'Then it is adopted without the setup screen (UC-01 main flow step 3)',
      () {
        final container = containerWith(
          probe: FakeProbe((_) => reachable()),
          config: const AppConfig(
            apiBaseUrl: 'https://fortuna.example',
            googleClientId: '',
            transport: Transport.http,
            databasePath: '',
          ),
        );

        final instance = container.read(instanceConfigProvider);

        expect(instance.address, 'https://fortuna.example');
        expect(instance.mode, AppMode.connected);
        expect(instance.isResolved, isTrue);
      },
    );

    test(
      'Given a stored address set by the user '
      'When the instance is restored '
      'Then it overrides the build-time default (UC-01 main flow step 3)',
      () async {
        final preferences = InMemoryPreferencesStore();
        await preferences.write(
          PreferenceKey.instanceAddress,
          'https://mine.example',
        );

        final container = containerWith(
          probe: FakeProbe((_) => reachable()),
          preferences: preferences,
          config: const AppConfig(
            apiBaseUrl: 'https://default.example',
            googleClientId: '',
            transport: Transport.http,
            databasePath: '',
          ),
        );

        await container.read(instanceConfigProvider.notifier).restore();

        final instance = container.read(instanceConfigProvider);
        expect(instance.address, 'https://mine.example');
        expect(instance.mode, AppMode.selfHosted);
      },
    );
  });
}
