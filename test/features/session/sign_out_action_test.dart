import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/session/ui/sign_out_action.dart';

class _UnclearableStore implements TokenStore {
  String? _token = 'a-token';

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => throw StateError('cannot clear');
}

const _session = SignedIn(
  role: Role.accountOwner,
  mode: AppMode.connected,
  subjectReference: 'subject-1',
);

Future<ProviderContainer> pumpWith(
  WidgetTester tester,
  TokenStore store,
) async {
  final container = ProviderContainer(
    overrides: [tokenStoreProvider.overrideWithValue(store)],
  );
  addTearDown(container.dispose);

  await container
      .read(sessionProvider.notifier)
      .grant(token: 'a-token', session: _session);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          appBar: null,
          body: Scaffold(appBar: null, body: Center(child: SignOutAction())),
        ),
      ),
    ),
  );

  return container;
}

void main() {
  group('SignOutAction', () {
    testWidgets('Given a session '
        'When sign out is pressed '
        'Then the session ends (UC-12 main flow)', (tester) async {
      final store = InMemoryTokenStore();
      final container = await pumpWith(tester, store);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(container.read(sessionProvider), isA<SignedOut>());
      expect(await store.read(), isNull);
    });

    testWidgets('Given the token cannot be removed '
        'When sign out is pressed '
        'Then the failure is shown and the session is kept (UC-12 AF-04)', (
      tester,
    ) async {
      final container = await pumpWith(tester, _UnclearableStore());

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('could not be ended on this device'),
        findsOneWidget,
      );
      expect(container.read(sessionProvider), isA<SignedIn>());
    });

    testWidgets('Given a successful sign out '
        'When it completes '
        'Then nothing is announced — the guard does the navigating', (
      tester,
    ) async {
      await pumpWith(tester, InMemoryTokenStore());

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
