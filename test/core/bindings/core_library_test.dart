import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';

void main() {
  group('coreLibraryFileName', () {
    test('Given each desktop platform '
        'When the core library is named '
        'Then it is the name fortuna-api publishes', () {
      expect(coreLibraryFileName(isWindows: true), 'fortuna_core.dll');
      expect(coreLibraryFileName(isWindows: false), 'libfortuna_core.so');
    });
  });

  group('classifyCoreLibrary', () {
    bool neverOpens(String path) => false;
    bool alwaysOpens(String path) => true;

    test('Given a platform that cannot host offline mode '
        'When the installation is classified '
        'Then the mode is not offered at all (UC-01 AF-03)', () {
      final availability = classifyCoreLibrary(
        platformSupportsOffline: false,
        locatedAt: '/anywhere/libfortuna_core.so',
        open: alwaysOpens,
      );

      expect(availability, CoreLibraryAvailability.unsupportedPlatform);
      expect(availability.canRunOffline, isFalse);
      // Nothing went wrong: the web was never going to offer this.
      expect(availability.isFailure, isFalse);
    });

    test('Given a desktop installation carrying no core library '
        'When it is classified '
        'Then the mode is absent rather than broken (UC-01 AF-03)', () {
      for (final located in [null, '']) {
        final availability = classifyCoreLibrary(
          platformSupportsOffline: true,
          locatedAt: located,
          open: alwaysOpens,
        );

        expect(availability, CoreLibraryAvailability.absent);
        expect(availability.canRunOffline, isFalse);
        expect(availability.isFailure, isFalse);
      }
    });

    test('Given a core library that is present and will not load '
        'When it is classified '
        'Then it is a failure the user is told about (UC-01 AF-04)', () {
      final availability = classifyCoreLibrary(
        platformSupportsOffline: true,
        locatedAt: '/opt/fortuna/libfortuna_core.so',
        open: neverOpens,
      );

      expect(availability, CoreLibraryAvailability.failedToLoad);
      expect(availability.canRunOffline, isFalse);
      expect(availability.isFailure, isTrue);
    });

    test('Given a core library that loads '
        'When it is classified '
        'Then desktop offline mode may be offered', () {
      final availability = classifyCoreLibrary(
        platformSupportsOffline: true,
        locatedAt: '/opt/fortuna/libfortuna_core.so',
        open: alwaysOpens,
      );

      expect(availability, CoreLibraryAvailability.available);
      expect(availability.canRunOffline, isTrue);
      expect(availability.isFailure, isFalse);
    });

    test('Given an unsupported platform '
        'When it is classified '
        'Then loading is never attempted', () {
      var attempted = false;

      classifyCoreLibrary(
        platformSupportsOffline: false,
        locatedAt: '/anywhere/libfortuna_core.so',
        open: (_) {
          attempted = true;
          return true;
        },
      );

      expect(attempted, isFalse);
    });
  });

  group('FixedCoreLibraryProbe', () {
    test('Given a probe told what to report '
        'When it is asked '
        'Then it reports it', () {
      for (final availability in CoreLibraryAvailability.values) {
        expect(FixedCoreLibraryProbe(availability).probe(), availability);
      }
    });
  });
}
