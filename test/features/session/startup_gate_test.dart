import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/app_config.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/session/data/session_repository.dart';
import 'package:fortuna_ui/features/session/ui/startup_gate.dart';

import '../../core/session/token_claims_test.dart' show tokenWith;

class _Repository implements SessionRepository {
  _Repository(this.next);

  Result<VerifiedProfile> Function() next;
  int calls = 0;

  @override
  Future<Result<VerifiedProfile>> verifyCurrentToken() async {
    calls++;
    return next();
  }
}

Widget harness({
  required TokenStore tokenStore,
  required SessionRepository repository,
}) => ProviderScope(
  overrides: [
    appConfigProvider.overrideWithValue(
      const AppConfig(
        apiBaseUrl: 'https://fortuna.example',
        googleClientId: '',
        transport: Transport.http,
        databasePath: '',
      ),
    ),
    tokenStoreProvider.overrideWithValue(tokenStore),
    sessionRepositoryProvider.overrideWithValue(repository),
  ],
  child: const StartupGate(
    child: MaterialApp(home: Scaffold(body: Text('the application'))),
  ),
);

void main() {
  group('StartupGate', () {
    testWidgets('Given restoration has not finished '
        'When the gate is built '
        'Then the application behind it is not shown', (tester) async {
      await tester.pumpWidget(
        harness(
          tokenStore: InMemoryTokenStore(),
          repository: _Repository(() => const Success(VerifiedProfile())),
        ),
      );

      // The first frame, before the post-frame restore has run.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('the application'), findsNothing);

      await tester.pumpAndSettle();
    });

    testWidgets('Given restoration completes '
        'When the gate settles '
        'Then the application is shown', (tester) async {
      await tester.pumpWidget(
        harness(
          tokenStore: InMemoryTokenStore(),
          repository: _Repository(() => const Success(VerifiedProfile())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('the application'), findsOneWidget);
    });

    testWidgets('Given the instance cannot be reached '
        'When the gate settles '
        'Then it explains and offers a retry, and the application stays hidden '
        '(UC-11 AF-03)', (tester) async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith({'id': 's', 'role': 3}));

      await tester.pumpWidget(
        harness(
          tokenStore: store,
          repository: _Repository(
            () => const Failure(
              message: 'The instance could not be reached.',
              kind: FailureKind.unreachable,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not restore your session'), findsOneWidget);
      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
      expect(find.text('the application'), findsNothing);
    });

    testWidgets('Given a failed restoration '
        'When retry is tapped and the instance answers '
        'Then the application is shown', (tester) async {
      final store = InMemoryTokenStore();
      await store.write(tokenWith({'id': 's', 'role': 3}));
      final repository = _Repository(
        () => const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      await tester.pumpWidget(
        harness(tokenStore: store, repository: repository),
      );
      await tester.pumpAndSettle();

      repository.next = () => const Success(VerifiedProfile());
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('the application'), findsOneWidget);
      expect(repository.calls, 2);
    });

    testWidgets('Given secure storage is unavailable '
        'When the gate settles '
        'Then it says so and offers no retry (UC-11 AF-04)', (tester) async {
      await tester.pumpWidget(
        harness(
          tokenStore: _UnavailableStore(),
          repository: _Repository(() => const Success(VerifiedProfile())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not restore your session'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    });
  });
}

class _UnavailableStore implements TokenStore {
  @override
  Future<String?> read() async => throw StateError('unavailable');

  @override
  Future<void> write(String token) async {}

  @override
  Future<void> clear() async {}
}
