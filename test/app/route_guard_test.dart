import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/app/route_guard.dart';
import 'package:fortuna_ui/app/routes.dart';
import 'package:fortuna_ui/core/bindings/core_library.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/session/session.dart';

const _configured = InstanceConfig(
  address: 'https://fortuna.example',
  mode: AppMode.connected,
  coreLibrary: CoreLibraryAvailability.absent,
);

const _unconfigured = InstanceConfig(
  address: '',
  mode: AppMode.connected,
  coreLibrary: CoreLibraryAvailability.absent,
);

const _owner = SignedIn(
  role: Role.accountOwner,
  mode: AppMode.connected,
  subjectReference: 'subject-1',
);

const _admin = SignedIn(
  role: Role.instanceAdministrator,
  mode: AppMode.connected,
  subjectReference: 'subject-2',
);

String? redirect({
  required InstanceConfig instance,
  required SessionState session,
  required String location,
  String? destination,
}) => resolveRedirect(
  instance: instance,
  session: session,
  location: location,
  destination: destination,
);

void main() {
  group('resolveRedirect', () {
    test('Given no instance is configured '
        'When any route is requested '
        'Then setup comes before even sign-in (UC-01)', () {
      for (final location in [Routes.home, Routes.signIn, Routes.admin]) {
        expect(
          redirect(
            instance: _unconfigured,
            session: const SignedOut(),
            location: location,
          ),
          Routes.setup,
          reason: '$location should redirect to setup',
        );
      }
    });

    test('Given no instance is configured '
        'When setup itself is requested '
        'Then it is admitted, so the redirect cannot loop', () {
      expect(
        redirect(
          instance: _unconfigured,
          session: const SignedOut(),
          location: Routes.setup,
        ),
        isNull,
      );
    });

    test(
      'Given no session '
      'When an authenticated route is requested '
      'Then it redirects to sign-in carrying the destination (UC-46 AF-02)',
      () {
        final target = redirect(
          instance: _configured,
          session: const SignedOut(),
          location: '/transactions',
        );

        expect(target, isNotNull);
        final uri = Uri.parse(target!);
        expect(uri.path, Routes.signIn);
        expect(
          uri.queryParameters[Routes.destinationParameter],
          '/transactions',
        );
      },
    );

    test('Given a remembered destination the role may reach '
        'When the user arrives at sign-in with a session '
        'Then they are sent there rather than to their home (UC-46 AF-02)', () {
      expect(
        redirect(
          instance: _configured,
          session: _owner,
          location: Routes.signIn,
          destination: Routes.settings,
        ),
        Routes.settings,
      );
    });

    test('Given a remembered destination the role may NOT reach '
        'When the user arrives at sign-in with a session '
        'Then it is refused and they go to their own home', () {
      // The remembered destination is a suggestion, not an instruction: an
      // owner who was sent away from /admin must not be delivered there by
      // having the guard trust its own query string.
      expect(
        redirect(
          instance: _configured,
          session: _owner,
          location: Routes.signIn,
          destination: Routes.admin,
        ),
        Routes.home,
      );
    });

    test('Given no remembered destination '
        'When the user arrives at sign-in with a session '
        'Then they go to their own home', () {
      expect(
        redirect(
          instance: _configured,
          session: _owner,
          location: Routes.signIn,
        ),
        Routes.home,
      );
    });

    test('Given a remembered destination that is sign-in itself '
        'When the user arrives with a session '
        'Then it does not loop', () {
      expect(
        redirect(
          instance: _configured,
          session: _owner,
          location: Routes.signIn,
          destination: Routes.signIn,
        ),
        Routes.home,
      );
    });

    test('Given settings '
        'When either role requests it '
        'Then both are admitted — presentation is not financial data', () {
      for (final session in [_owner, _admin]) {
        expect(
          redirect(
            instance: _configured,
            session: session,
            location: Routes.settings,
          ),
          isNull,
        );
      }
    });

    test('Given a two-factor challenge is outstanding '
        'When an authenticated route is requested '
        'Then it is treated as having no session (UC-46 AF-03, BR-19)', () {
      final pending = ChallengePending(
        challengeToken: 'challenge',
        methods: const ['authenticator'],
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      );

      final target = redirect(
        instance: _configured,
        session: pending,
        location: Routes.home,
      );

      expect(Uri.parse(target!).path, Routes.signIn);
    });

    test(
      'Given an account owner '
      'When the administrative area is requested '
      'Then they are redirected to their own home (UC-46 AF-01, FR-AD-05)',
      () {
        expect(
          redirect(
            instance: _configured,
            session: _owner,
            location: Routes.admin,
          ),
          Routes.home,
        );
      },
    );

    test(
      'Given an account owner '
      'When a route nested under the administrative area is requested '
      'Then it is refused too — the prefix is guarded, not just the root',
      () {
        expect(
          redirect(
            instance: _configured,
            session: _owner,
            location: '${Routes.admin}/instances/1',
          ),
          Routes.home,
        );
      },
    );

    test('Given an instance administrator '
        'When a financial route is requested '
        'Then they are kept out of it entirely (FR-AD-03)', () {
      expect(
        redirect(instance: _configured, session: _admin, location: Routes.home),
        Routes.admin,
      );
    });

    test('Given an instance administrator '
        'When the administrative area is requested '
        'Then it is admitted', () {
      expect(
        redirect(
          instance: _configured,
          session: _admin,
          location: Routes.admin,
        ),
        isNull,
      );
    });

    test(
      'Given a signed-in user '
      'When an anonymous route is requested '
      'Then they are sent to their own home rather than shown sign-in again',
      () {
        for (final location in Routes.anonymous) {
          expect(
            redirect(
              instance: _configured,
              session: _owner,
              location: location,
            ),
            Routes.home,
          );
          expect(
            redirect(
              instance: _configured,
              session: _admin,
              location: location,
            ),
            Routes.admin,
          );
        }
      },
    );

    test('Given an account owner '
        'When their own home is requested '
        'Then it is admitted', () {
      expect(
        redirect(instance: _configured, session: _owner, location: Routes.home),
        isNull,
      );
    });

    test('Given desktop offline mode with no address '
        'When a route is requested '
        'Then the instance counts as resolved and setup is not forced', () {
      const offline = InstanceConfig(
        address: '',
        mode: AppMode.desktopOffline,
        coreLibrary: CoreLibraryAvailability.available,
      );

      expect(
        redirect(
          instance: offline,
          session: const SignedOut(),
          location: Routes.signIn,
        ),
        isNull,
      );
    });
  });

  group('homeFor', () {
    test('Given each role '
        'When its home is resolved '
        'Then an administrator never lands in the financial application', () {
      expect(homeFor(Role.accountOwner), Routes.home);
      expect(homeFor(Role.instanceAdministrator), Routes.admin);
    });
  });
}
