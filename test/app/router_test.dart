/// The guard, exercised through real navigation rather than as a function.
///
/// `route_guard_test.dart` proves the decision; this proves it is actually
/// applied — to a typed URL, to a deep link, and again on every navigation
/// rather than once at sign-in.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/app/router.dart';
import 'package:fortuna_ui/app/routes.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/administration/data/health_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:go_router/go_router.dart';

class _Health implements HealthRepository {
  @override
  Future<Result<InstanceHealth>> readDetailed() async => const Success(
    InstanceHealth(
      status: HealthStatus.healthy,
      rawStatus: 'Healthy',
      services: [],
    ),
  );
}

class _Currencies implements CurrencyRepository {
  @override
  Future<Result<List<SupportedCurrency>>> listSupported() async =>
      const Success([]);
}

const _owner = SignedIn(
  role: Role.accountOwner,
  mode: AppMode.connected,
  subjectReference: 'owner',
);

const _admin = SignedIn(
  role: Role.instanceAdministrator,
  mode: AppMode.connected,
  subjectReference: 'admin',
);

Future<(ProviderContainer, GoRouter)> pumpApp(
  WidgetTester tester, {
  SessionState session = const SignedOut(),
  String? at,
}) async {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        const AppConfig(
          apiBaseUrl: 'https://fortuna.example',
          googleClientId: '',
          transport: Transport.http,
          databasePath: '',
        ),
      ),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      healthRepositoryProvider.overrideWithValue(_Health()),
      currencyRepositoryProvider.overrideWithValue(_Currencies()),
    ],
  );
  addTearDown(container.dispose);

  if (session is SignedIn) {
    await container
        .read(sessionProvider.notifier)
        .grant(token: 'a-token', session: session);
  }

  final router = container.read(routerProvider);
  if (at != null) router.go(at);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();

  return (container, router);
}

String locationOf(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

void main() {
  group('The router applies the guard', () {
    testWidgets('Given no session '
        'When an authenticated route is typed directly '
        'Then the guard sends them to sign-in with the destination remembered '
        '(UC-46 AF-02)', (tester) async {
      final (_, router) = await pumpApp(tester, at: Routes.settings);

      final uri = Uri.parse(locationOf(router));
      expect(uri.path, Routes.signIn);
      expect(uri.queryParameters[Routes.destinationParameter], Routes.settings);
    });

    testWidgets('Given an account owner '
        'When the administrative route is typed directly '
        'Then they land on their own home (UC-46 AF-01)', (tester) async {
      final (_, router) = await pumpApp(
        tester,
        session: _owner,
        at: Routes.admin,
      );

      expect(locationOf(router), Routes.home);
    });

    testWidgets('Given an instance administrator '
        'When a financial route is typed directly '
        'Then they land in the administrative area (FR-AD-03)', (tester) async {
      final (_, router) = await pumpApp(
        tester,
        session: _admin,
        at: Routes.home,
      );

      expect(locationOf(router), Routes.admin);
    });

    testWidgets('Given a route that does not exist '
        'When it is requested '
        'Then a not-found screen is shown inside the application, not a blank '
        'page (UC-46 AF-05)', (tester) async {
      await pumpApp(tester, session: _owner, at: '/nowhere');

      expect(find.text('Not found'), findsOneWidget);
      expect(find.textContaining('/nowhere'), findsOneWidget);
      // Reachable from it, rather than a dead end.
      expect(
        find.widgetWithText(FilledButton, 'Go to the overview'),
        findsOneWidget,
      );
    });

    testWidgets('Given a signed-in owner '
        'When the session ends '
        'Then the guard re-evaluates and moves them out (UC-46 AF-06)', (
      tester,
    ) async {
      final (container, router) = await pumpApp(tester, session: _owner);
      expect(locationOf(router), Routes.home);

      await container.read(sessionProvider.notifier).signOut();
      await tester.pumpAndSettle();

      expect(Uri.parse(locationOf(router)).path, Routes.signIn);
    });

    testWidgets('Given a signed-out user on sign-in '
        'When a session appears '
        'Then the guard re-evaluates and admits them (UC-46 AF-06)', (
      tester,
    ) async {
      final (container, router) = await pumpApp(tester);
      expect(Uri.parse(locationOf(router)).path, Routes.signIn);

      await container
          .read(sessionProvider.notifier)
          .grant(token: 'a-token', session: _owner);
      await tester.pumpAndSettle();

      expect(locationOf(router), Routes.home);
    });

    testWidgets(
      'Given an owner who was sent away from the administrative area '
      'When they navigate again '
      'Then it is still refused — the refusal is not a one-off (UC-46 AF-04)',
      (tester) async {
        final (_, router) = await pumpApp(tester, session: _owner);

        for (var attempt = 0; attempt < 3; attempt++) {
          router.go(Routes.admin);
          await tester.pumpAndSettle();
          expect(locationOf(router), Routes.home);
        }
      },
    );
  });
}
