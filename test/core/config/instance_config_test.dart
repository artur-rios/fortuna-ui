import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/session/session.dart';

void main() {
  group('InstanceConfigController.isWellFormedAddress', () {
    test('Given a well-formed http or https address '
        'When it is validated '
        'Then it is accepted', () {
      for (final address in [
        'https://fortuna.example',
        'http://localhost:5000',
        'https://fortuna.example:8443/api',
      ]) {
        expect(
          InstanceConfigController.isWellFormedAddress(address),
          isTrue,
          reason: '$address should be accepted',
        );
      }
    });

    test(
      'Given a malformed address '
      'When it is validated '
      'Then it is rejected before any request is attempted (UC-01 AF-01)',
      () {
        for (final address in [
          '',
          '   ',
          'fortuna.example',
          'ftp://fortuna.example',
          'https://',
          'not a url',
        ]) {
          expect(
            InstanceConfigController.isWellFormedAddress(address),
            isFalse,
            reason: '"$address" should be rejected',
          );
        }
      },
    );
  });

  group('InstanceConfig', () {
    test('Given a connected instance with an address '
        'When it is asked whether it is resolved '
        'Then it is', () {
      const config = InstanceConfig(
        address: 'https://fortuna.example',
        mode: AppMode.connected,
        offlineAvailable: false,
      );

      expect(config.isResolved, isTrue);
    });

    test('Given a connected instance with no address '
        'When it is asked whether it is resolved '
        'Then it is not, and the user is sent to setup', () {
      const config = InstanceConfig(
        address: '',
        mode: AppMode.connected,
        offlineAvailable: false,
      );

      expect(config.isResolved, isFalse);
    });

    test(
      'Given desktop offline mode '
      'When it is asked whether it is resolved '
      'Then it is, despite having no address — there is nothing to address',
      () {
        const config = InstanceConfig(
          address: '',
          mode: AppMode.desktopOffline,
          offlineAvailable: true,
        );

        expect(config.isResolved, isTrue);
      },
    );
  });

  group('AppConfig', () {
    test('Given a build with no API address '
        'When the configuration is read '
        'Then it names no default instance rather than failing', () {
      const config = AppConfig(
        apiBaseUrl: '',
        googleClientId: '',
        transport: Transport.http,
        databasePath: '',
      );

      expect(config.hasDefaultInstance, isFalse);
      expect(config.supportsGoogleSignIn, isFalse);
      expect(config.isOffline, isFalse);
    });

    test('Given a build wired for FFI '
        'When the configuration is read '
        'Then it reports itself as offline', () {
      const config = AppConfig(
        apiBaseUrl: '',
        googleClientId: '',
        transport: Transport.ffi,
        databasePath: '',
      );

      expect(config.isOffline, isTrue);
    });
  });
}
