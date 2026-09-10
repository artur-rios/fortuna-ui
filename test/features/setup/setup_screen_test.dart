import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/setup/data/instance_probe.dart';
import 'package:fortuna_ui/features/setup/ui/setup_screen.dart';

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

Future<void> pumpSetup(
  WidgetTester tester, {
  required FakeProbe probe,
  CoreLibraryAvailability core = CoreLibraryAvailability.unsupportedPlatform,
  PreferencesStore? preferences,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            apiBaseUrl: '',
            googleClientId: '',
            transport: Transport.http,
            databasePath: '',
          ),
        ),
        preferencesStoreProvider.overrideWithValue(
          preferences ?? InMemoryPreferencesStore(),
        ),
        coreLibraryProbeProvider.overrideWithValue(FixedCoreLibraryProbe(core)),
        instanceProbeProvider.overrideWithValue(probe),
      ],
      child: const MaterialApp(home: SetupScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('SetupScreen', () {
    testWidgets('Given the screen is shown '
        'When it settles '
        'Then the address field and the connect action are offered', (
      tester,
    ) async {
      await pumpSetup(tester, probe: FakeProbe((_) => reachable()));

      expect(find.text('Set up your instance'), findsOneWidget);
      expect(find.byKey(const Key('setup.address')), findsOneWidget);
      expect(find.byKey(const Key('setup.connect')), findsOneWidget);
    });

    testWidgets('Given a malformed address '
        'When connect is pressed '
        'Then the field says so and nothing is probed (UC-01 AF-01)', (
      tester,
    ) async {
      final probe = FakeProbe((_) => reachable());
      await pumpSetup(tester, probe: probe);

      await tester.enterText(
        find.byKey(const Key('setup.address')),
        'fortuna.example',
      );
      await tester.tap(find.byKey(const Key('setup.connect')));
      await tester.pumpAndSettle();

      expect(find.textContaining('including http://'), findsOneWidget);
      expect(probe.probed, isEmpty);
    });

    testWidgets('Given an unreachable instance '
        'When connect is pressed '
        'Then the reason is shown and the user stays on setup (UC-01 AF-02)', (
      tester,
    ) async {
      await pumpSetup(
        tester,
        probe: FakeProbe(
          (_) => const Failure<InstanceIdentity>(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('setup.address')),
        'https://nowhere.example',
      );
      await tester.tap(find.byKey(const Key('setup.connect')));
      await tester.pumpAndSettle();

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.byKey(const Key('setup.address')), findsOneWidget);
    });

    testWidgets('Given an instance speaking another contract '
        'When connect is pressed '
        'Then the incompatibility names both versions (UC-01 AF-05)', (
      tester,
    ) async {
      await pumpSetup(
        tester,
        probe: FakeProbe((_) => reachable(version: 'v9')),
      );

      await tester.enterText(
        find.byKey(const Key('setup.address')),
        'https://fortuna.example',
      );
      await tester.tap(find.byKey(const Key('setup.connect')));
      await tester.pumpAndSettle();

      expect(find.textContaining('contract v9'), findsOneWidget);
      expect(find.textContaining('built for v1'), findsOneWidget);
    });

    testWidgets('Given a target that cannot run offline '
        'When the screen is shown '
        'Then the offline option is not offered at all (UC-01 AF-03)', (
      tester,
    ) async {
      for (final core in [
        CoreLibraryAvailability.unsupportedPlatform,
        CoreLibraryAvailability.absent,
      ]) {
        await pumpSetup(
          tester,
          probe: FakeProbe((_) => reachable()),
          core: core,
        );

        expect(
          find.byKey(const Key('setup.offline')),
          findsNothing,
          reason: '$core should not offer offline mode',
        );
      }
    });

    testWidgets('Given an installation whose core loads '
        'When the screen is shown '
        'Then desktop offline mode is offered', (tester) async {
      await pumpSetup(
        tester,
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.available,
      );

      expect(find.byKey(const Key('setup.offline')), findsOneWidget);
    });

    testWidgets('Given a core library that will not load '
        'When the screen is shown '
        'Then it says so and still offers the connected path (UC-01 AF-04)', (
      tester,
    ) async {
      await pumpSetup(
        tester,
        probe: FakeProbe((_) => reachable()),
        core: CoreLibraryAvailability.failedToLoad,
      );

      expect(find.textContaining('could not be loaded'), findsOneWidget);
      // The point of AF-04: the connected paths remain available.
      expect(find.byKey(const Key('setup.connect')), findsOneWidget);
      expect(find.byKey(const Key('setup.offline')), findsNothing);
    });

    testWidgets('Given a reachable, compatible instance '
        'When connect is pressed '
        'Then the address is persisted and the instance resolves '
        '(UC-01 main flow)', (tester) async {
      final preferences = InMemoryPreferencesStore();
      await pumpSetup(
        tester,
        probe: FakeProbe((_) => reachable()),
        preferences: preferences,
      );

      await tester.enterText(
        find.byKey(const Key('setup.address')),
        'https://fortuna.example',
      );
      await tester.tap(find.byKey(const Key('setup.connect')));
      await tester.pumpAndSettle();

      expect(
        await preferences.read(PreferenceKey.instanceAddress),
        'https://fortuna.example',
      );
    });

    testWidgets('Given offline mode is offered '
        'When it is chosen '
        'Then the installation enters desktop offline mode', (tester) async {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              apiBaseUrl: '',
              googleClientId: '',
              transport: Transport.http,
              databasePath: '',
            ),
          ),
          preferencesStoreProvider.overrideWithValue(
            InMemoryPreferencesStore(),
          ),
          coreLibraryProbeProvider.overrideWithValue(
            const FixedCoreLibraryProbe(CoreLibraryAvailability.available),
          ),
          instanceProbeProvider.overrideWithValue(FakeProbe((_) => reachable())),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SetupScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('setup.offline')));
      await tester.pumpAndSettle();

      expect(
        container.read(instanceConfigProvider).mode,
        AppMode.desktopOffline,
      );
    });
  });
}
