import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/administration/data/health_repository.dart';
import 'package:fortuna_ui/features/administration/ui/instance_health_screen.dart';

class FakeHealthRepository implements HealthRepository {
  FakeHealthRepository(this.next);

  Result<InstanceHealth> Function() next;
  int calls = 0;

  @override
  Future<Result<InstanceHealth>> readDetailed() async {
    calls++;
    return next();
  }
}

const _degraded = InstanceHealth(
  status: HealthStatus.degraded,
  rawStatus: 'Degraded',
  services: [
    ServiceHealth(
      name: 'Database',
      status: HealthStatus.healthy,
      rawStatus: 'Healthy',
    ),
    ServiceHealth(
      name: 'Aggregator',
      status: HealthStatus.unhealthy,
      rawStatus: 'Unhealthy',
    ),
    ServiceHealth(
      name: 'Rate source',
      status: HealthStatus.notConfigured,
      rawStatus: 'NotConfigured',
    ),
  ],
);

Future<FakeHealthRepository> pumpHealth(
  WidgetTester tester,
  Result<InstanceHealth> Function() next,
) async {
  final repository = FakeHealthRepository(next);
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      healthRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: InstanceHealthScreen()),
    ),
  );
  await tester.pumpAndSettle();

  return repository;
}

void main() {
  group('InstanceHealthScreen', () {
    testWidgets('Given a degraded instance '
        'When the screen settles '
        'Then the aggregate, each dependency and the cause are shown '
        '(UC-45 main flow, AF-05)', (tester) async {
      await pumpHealth(tester, () => const Success(_degraded));

      expect(find.text('Instance'), findsOneWidget);
      expect(find.text('Degraded'), findsWidgets);
      expect(find.text('Database'), findsOneWidget);
      expect(find.text('Aggregator'), findsOneWidget);
      // AF-05: which dependency caused it.
      expect(find.textContaining('Caused by Aggregator'), findsOneWidget);
    });

    testWidgets('Given a dependency that is not configured '
        'When the screen settles '
        'Then it reads as not configured, not as unhealthy (UC-45 AF-02)', (
      tester,
    ) async {
      await pumpHealth(tester, () => const Success(_degraded));

      expect(find.text('Not configured'), findsOneWidget);
      // And it is not named as a cause.
      expect(find.textContaining('Rate source.'), findsNothing);
    });

    testWidgets('Given the health cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry and no partial view '
        '(UC-45 AF-01)', (tester) async {
      await pumpHealth(
        tester,
        () => const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
      // No partial report: half a health report reads as reassurance.
      expect(find.text('Database'), findsNothing);
    });

    testWidgets('Given the API refuses the detailed check '
        'When the screen settles '
        'Then the refusal is shown and no data is (UC-45 AF-03)', (
      tester,
    ) async {
      await pumpHealth(
        tester,
        () => const Failure(
          message: 'Administering the instance confers no access.',
          kind: FailureKind.forbidden,
        ),
      );

      expect(
        find.text('Administering the instance confers no access.'),
        findsOneWidget,
      );
      expect(find.text('Instance'), findsNothing);
    });

    testWidgets('Given a failed read '
        'When retry is pressed and the instance answers '
        'Then the report is shown', (tester) async {
      final repository = await pumpHealth(
        tester,
        () => const Failure(
          message: 'unreachable',
          kind: FailureKind.unreachable,
        ),
      );

      repository.next = () => const Success(_degraded);
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Database'), findsOneWidget);
      expect(repository.calls, 2);
    });

    testWidgets('Given the administrative area '
        'When it is displayed at all '
        'Then it carries no currency symbol or amount anywhere (FR-AD-03)', (
      tester,
    ) async {
      await pumpHealth(tester, () => const Success(_degraded));

      // The guarantee this area exists to keep: running the instance is not
      // a reason to read its contents.
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((widget) => widget.data ?? '')
          .join(' ');

      expect(texts, isNot(matches(RegExp(r'[$€£R]\s?\d'))));
      expect(texts, isNot(contains('Balance')));
      expect(texts, isNot(contains('Transaction')));
    });
  });
}
