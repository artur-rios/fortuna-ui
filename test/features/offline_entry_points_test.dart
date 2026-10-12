/// The entry points the offline core does not implement (UC-02, FR-DA-14).
///
/// Each is checked both ways: offline it says "Not available offline" with the
/// core's reason and offers neither the action nor a retry; online it is
/// exactly what it was, because over HTTP nothing is unavailable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/network/offline_capabilities.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/holdings/data/statement_repository.dart';
import 'package:fortuna_ui/features/ingestion/data/import_job_repository.dart';
import 'package:fortuna_ui/shared/widgets/offline_unavailable.dart';

import '../core/network/offline_capabilities_test.dart'
    show
        exportsReason,
        importsReason,
        installmentsReason,
        offlineCore,
        planningReason,
        reconciliationReason,
        reportsReason,
        statementsReason,
        transfersReason;
import 'holdings/credit_cards_test.dart' show FakeCards, card, pumpCards;
import 'holdings/statements_test.dart'
    show FakeStatements, pumpStatement, pumpStatements;
import 'ingestion/import_file_screen_test.dart' show pumpImport;
import 'ingestion/import_jobs_screen_test.dart' show job, pumpJobs;
import 'insight/aggregation_test.dart' show FakeAggregations, pumpInsight;
import 'insight/projections_test.dart' show FakeProjections, pumpProjections;
import 'planning/budgets_test.dart' show FakeBudgets, budget, pumpBudgets;
import 'planning/goals_test.dart' show FakeGoals, goal, pumpGoals;
import 'transactions/reconcile_transaction_test.dart'
    show ReconcilableTransactions, pumpTransaction;
import 'transactions/record_installment_test.dart'
    show FakeInstallments, pumpInstallment;
import 'transactions/record_transfer_test.dart'
    show FakeTransfers, pumpTransfer;
import 'transactions/transactions_table_test.dart'
    show SearchableTransactions, pumpTable;

/// Desktop offline mode, against a core that publishes its gaps.
///
/// Already read, as it is in the application by the time any of these screens
/// is reached: `main` reads the capabilities when offline mode starts.
final List<Override> offline = [
  coreCapabilitiesProvider.overrideWithValue(AsyncData(offlineCore)),
];

/// Counts reads, so "nothing was asked" is something a test can see.
class CountingStatements extends FakeStatements {
  int lists = 0;
  int reads = 0;

  @override
  Future<Result<List<CardStatement>>> listForCard(String creditCardId) {
    lists++;
    return super.listForCard(creditCardId);
  }

  @override
  Future<Result<CardStatement>> read(String statementId) {
    reads++;
    return super.read(statementId);
  }
}

Finder get notice => find.byType(OfflineUnavailableNotice);

/// The disabled control's explanation, wherever it is rendered.
Finder explanation(String reason) => find.text(notAvailableOffline(reason));

void expectNoRetry() {
  expect(find.text('Try again'), findsNothing);
  expect(find.text('Retry'), findsNothing);
}

void main() {
  group('Insight (UC-36)', () {
    testWidgets('Given offline mode and a core without reports '
        'When the screen opens '
        "Then it says not available offline with the core's reason, asks "
        'nothing and offers no retry', (tester) async {
      final fake = FakeAggregations();

      await pumpInsight(tester, fake, extra: offline);

      expect(notice, findsOneWidget);
      expect(find.text(notAvailableOfflineTitle), findsOneWidget);
      expect(find.text(reportsReason), findsOneWidget);
      expect(fake.asked, isEmpty);
      expect(find.byKey(const Key('insight.grouping')), findsNothing);
      expectNoRetry();
    });

    testWidgets('Given the HTTP transport '
        'When the screen opens '
        'Then the chart is asked for and shown as before', (tester) async {
      final fake = FakeAggregations();

      await pumpInsight(tester, fake);

      expect(notice, findsNothing);
      expect(fake.asked, isNotEmpty);
      expect(find.byKey(const Key('insight.grouping')), findsOneWidget);
    });
  });

  group('Projections (UC-38)', () {
    testWidgets('Given offline mode '
        'When the screen opens '
        'Then it explains, and nothing is asked', (tester) async {
      final fake = FakeProjections();

      await pumpProjections(tester, fake, extra: offline);

      expect(notice, findsOneWidget);
      expect(find.text(reportsReason), findsOneWidget);
      expect(fake.horizonsAsked, isEmpty);
      expectNoRetry();
    });

    testWidgets('Given the HTTP transport '
        'When the screen opens '
        'Then the projection is asked for', (tester) async {
      final fake = FakeProjections();

      await pumpProjections(tester, fake);

      expect(notice, findsNothing);
      expect(fake.horizonsAsked, isNotEmpty);
    });
  });

  group('Card statements (UC-16)', () {
    testWidgets('Given offline mode '
        'When a card is listed '
        'Then its statements are offered disabled, with the reason', (
      tester,
    ) async {
      await pumpCards(
        tester,
        FakeCards(onList: () => Success([card()])),
        extra: offline,
      );

      final button = tester.widget<ButtonStyleButton>(
        find.byKey(const Key('cards.statements.c1')),
      );
      expect(button.onPressed, isNull);
      expect(
        find.byTooltip(notAvailableOffline(statementsReason)),
        findsOneWidget,
      );
    });

    testWidgets('Given the HTTP transport '
        'When a card is listed '
        'Then its statements are offered', (tester) async {
      await pumpCards(tester, FakeCards(onList: () => Success([card()])));

      final button = tester.widget<ButtonStyleButton>(
        find.byKey(const Key('cards.statements.c1')),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Given offline mode '
        "When a card's cycles or one statement are opened directly "
        'Then each explains, and nothing is read', (tester) async {
      final fake = CountingStatements();

      await pumpStatements(tester, fake, extra: offline);
      expect(notice, findsOneWidget);
      expect(find.text(statementsReason), findsOneWidget);
      expectNoRetry();

      await pumpStatement(tester, fake, extra: offline);
      expect(notice, findsOneWidget);
      expect(find.byKey(const Key('statement.retry')), findsNothing);

      expect(fake.lists, 0);
      expect(fake.reads, 0);
    });

    testWidgets('Given a core that reads statements but cannot close or settle '
        'When an open statement is opened '
        'Then it is shown, and closing is replaced by the reason', (
      tester,
    ) async {
      final fake = CountingStatements();

      await pumpStatement(
        tester,
        fake,
        extra: [
          coreCapabilitiesProvider.overrideWithValue(
            const AsyncData(
              CoreCapabilities(
                notImplemented: [
                  NotImplementedRoute(
                    method: 'POST',
                    path: '/api/statements/{id}/close',
                    reason: statementsReason,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      expect(fake.reads, 1);
      expect(notice, findsNothing);
      expect(
        find.byKey(const Key('statement.actionsUnavailable')),
        findsOneWidget,
      );
      expect(explanation(statementsReason), findsOneWidget);
      expect(find.byKey(const Key('statement.close')), findsNothing);
      expect(find.byKey(const Key('statement.settle')), findsNothing);
    });

    testWidgets('Given the HTTP transport '
        "When a card's cycles are opened "
        'Then they are read', (tester) async {
      final fake = CountingStatements();

      await pumpStatements(tester, fake);

      expect(notice, findsNothing);
      expect(fake.lists, 1);
    });
  });

  group('Transfers and installment purchases (UC-21, UC-22)', () {
    testWidgets('Given offline mode '
        'When recording a transfer is opened '
        'Then the form is not offered, and the reason is', (tester) async {
      await pumpTransfer(tester, transfers: FakeTransfers(), extra: offline);

      expect(notice, findsOneWidget);
      expect(find.text(transfersReason), findsOneWidget);
      expect(find.byKey(const Key('recordTransfer.submit')), findsNothing);
    });

    testWidgets('Given offline mode '
        'When recording an installment purchase is opened '
        'Then the form is not offered, and the reason is', (tester) async {
      await pumpInstallment(
        tester,
        installments: FakeInstallments(),
        extra: offline,
      );

      expect(notice, findsOneWidget);
      expect(find.text(installmentsReason), findsOneWidget);
      expect(find.byKey(const Key('recordInstallment.submit')), findsNothing);
    });

    testWidgets('Given the HTTP transport '
        'When recording a transfer is opened '
        'Then the form is offered as before', (tester) async {
      await pumpTransfer(tester);

      expect(notice, findsNothing);
      expect(find.byKey(const Key('recordTransfer.submit')), findsOneWidget);
    });

    testWidgets('Given the HTTP transport '
        'When recording an installment purchase is opened '
        'Then the form is offered as before', (tester) async {
      await pumpInstallment(tester);

      expect(notice, findsNothing);
      expect(find.byKey(const Key('recordInstallment.submit')), findsOneWidget);
    });
  });

  group('Imports (UC-32, UC-33)', () {
    testWidgets('Given offline mode '
        'When importing a file is opened '
        'Then no file can be chosen, and the reason is shown', (tester) async {
      await pumpImport(tester, extra: offline);

      expect(notice, findsOneWidget);
      expect(find.text(importsReason), findsOneWidget);
      expect(find.text('Choose file'), findsNothing);
    });

    testWidgets('Given the HTTP transport '
        'When importing a file is opened '
        'Then the sources are offered', (tester) async {
      await pumpImport(tester);

      expect(notice, findsNothing);
      expect(find.text('Choose file'), findsWidgets);
    });

    testWidgets('Given offline mode and a failed import '
        'When the jobs are listed '
        'Then retrying is not offered, and the reason is', (tester) async {
      await pumpJobs(
        tester,
        () => Success([job(state: JobState.failed, failureReason: 'Bad.')]),
        extra: offline,
      );

      expect(find.text('Retry this import'), findsNothing);
      expect(explanation(importsReason), findsOneWidget);
    });

    testWidgets('Given the HTTP transport and a failed import '
        'When the jobs are listed '
        'Then retrying is offered', (tester) async {
      await pumpJobs(
        tester,
        () => Success([job(state: JobState.failed, failureReason: 'Bad.')]),
      );

      expect(find.text('Retry this import'), findsOneWidget);
      expect(explanation(importsReason), findsNothing);
    });
  });

  group('Data-set export (UC-39)', () {
    IconButton exportButton(WidgetTester tester) =>
        tester.widget<IconButton>(find.byKey(const Key('transactions.export')));

    testWidgets('Given offline mode '
        'When the transactions are shown '
        'Then exporting is disabled, with the reason', (tester) async {
      await pumpTable(tester, SearchableTransactions(), extra: offline);

      expect(exportButton(tester).onPressed, isNull);
      expect(
        find.byTooltip(notAvailableOffline(exportsReason)),
        findsOneWidget,
      );
    });

    testWidgets('Given the HTTP transport '
        'When the transactions are shown '
        'Then exporting is offered', (tester) async {
      await pumpTable(tester, SearchableTransactions());

      expect(exportButton(tester).onPressed, isNotNull);
    });
  });

  group('Budget consumption and goal progress (UC-28, UC-29)', () {
    testWidgets('Given offline mode '
        'When budgets are listed '
        'Then consumption is explained as not available offline, and the '
        'ceiling is still shown', (tester) async {
      await pumpBudgets(
        tester,
        FakeBudgets(onList: () => Success([budget()])),
        extra: offline,
      );

      expect(explanation(planningReason), findsOneWidget);
      expect(find.byKey(const Key('budgets.spent.b1')), findsNothing);
      expect(find.byKey(const Key('budgets.amount.b1')), findsOneWidget);
    });

    testWidgets('Given the HTTP transport '
        'When budgets are listed '
        'Then consumption is shown', (tester) async {
      await pumpBudgets(tester, FakeBudgets(onList: () => Success([budget()])));

      expect(explanation(planningReason), findsNothing);
      expect(find.byKey(const Key('budgets.spent.b1')), findsOneWidget);
    });

    testWidgets('Given offline mode '
        'When goals are listed '
        'Then progress is explained as not available offline', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(onList: () => Success([goal()])),
        extra: offline,
      );

      expect(explanation(planningReason), findsOneWidget);
      expect(find.byKey(const Key('goals.saved.g1')), findsNothing);
      expect(find.byKey(const Key('goals.target.g1')), findsOneWidget);
    });

    testWidgets('Given the HTTP transport '
        'When goals are listed '
        'Then progress is shown', (tester) async {
      await pumpGoals(tester, FakeGoals(onList: () => Success([goal()])));

      expect(explanation(planningReason), findsNothing);
      expect(find.byKey(const Key('goals.saved.g1')), findsOneWidget);
    });
  });

  group('Reconciliation (UC-24)', () {
    testWidgets('Given offline mode and an unreconciled transaction '
        'When it is opened '
        'Then reconciling is not offered, and the reason is', (tester) async {
      final fake = ReconcilableTransactions();

      await pumpTransaction(tester, fake, extra: offline);

      expect(find.byKey(const Key('transaction.reconcile')), findsOneWidget);
      expect(
        find.byKey(const Key('transaction.reconcile.confirm')),
        findsNothing,
      );
      expect(explanation(reconciliationReason), findsOneWidget);
      expect(fake.reconciled, isEmpty);
    });

    testWidgets('Given the HTTP transport and an unreconciled transaction '
        'When it is opened '
        'Then reconciling is offered', (tester) async {
      await pumpTransaction(tester, ReconcilableTransactions());

      expect(
        find.byKey(const Key('transaction.reconcile.confirm')),
        findsOneWidget,
      );
      expect(explanation(reconciliationReason), findsNothing);
    });
  });
}
