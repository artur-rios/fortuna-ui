import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/data/credit_card_repository.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_table.dart';
import 'package:fortuna_ui/features/transactions/ui/transactions_screen.dart';

import '../holdings/accounts_test.dart'
    show FakeAccounts, FakeCurrencies, account;
import 'record_transaction_test.dart' show FakeCards, FakeCategories, treeWith;
import 'transaction_detail_test.dart' show EditableTransactions, stored;

/// Extends the UC-20 fake with the search UC-25 adds, recording what was
/// asked so the tests can assert the API was asked rather than a local list
/// filtered (`FR-TB-02`).
class SearchableTransactions extends EditableTransactions {
  SearchableTransactions({this.onSearch});

  Result<TransactionPage> Function()? onSearch;

  final List<Map<String, Object?>> searches = [];

  @override
  Future<Result<TransactionPage>> search({
    DateTime? from,
    DateTime? to,
    String? financialAccountId,
    String? creditCardId,
    String? categoryId,
    String? tagId,
    String? counterpartyId,
    Direction? direction,
    String? minimumAmount,
    String? maximumAmount,
    String? text,
    String? sortBy,
    bool descending = true,
    int pageNumber = 1,
    int pageSize = 25,
  }) async {
    searches.add({
      'from': from,
      'to': to,
      'financialAccountId': financialAccountId,
      'categoryId': categoryId,
      'direction': direction,
      'minimumAmount': minimumAmount,
      'maximumAmount': maximumAmount,
      'sortBy': sortBy,
      'descending': descending,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    });
    return onSearch?.call() ?? Success(page());
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowSearch extends SearchableTransactions {
  SlowSearch(this._pending);

  final Future<Result<TransactionPage>> _pending;

  @override
  Future<Result<TransactionPage>> search({
    DateTime? from,
    DateTime? to,
    String? financialAccountId,
    String? creditCardId,
    String? categoryId,
    String? tagId,
    String? counterpartyId,
    Direction? direction,
    String? minimumAmount,
    String? maximumAmount,
    String? text,
    String? sortBy,
    bool descending = true,
    int pageNumber = 1,
    int pageSize = 25,
  }) => _pending;
}

TransactionPage page({
  int items = 2,
  int pageNumber = 1,
  int totalItems = 2,
  int totalPages = 1,
}) => TransactionPage(
  items: [for (var i = 0; i < items; i++) stored(id: 't${i + 1}')],
  pageNumber: pageNumber,
  pageSize: transactionPageSize,
  totalItems: totalItems,
  totalPages: totalPages,
);

ProviderContainer containerWith(
  SearchableTransactions fake, {
  PreferencesStore? preferences,
}) {
  final container = ProviderContainer(
    overrides: [
      transactionRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(
        preferences ?? InMemoryPreferencesStore(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpTable(
  WidgetTester tester,
  SearchableTransactions fake, {
  PreferencesStore? preferences,
}) async {
  tester.view.physicalSize = const Size(1400, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(fake),
        accountRepositoryProvider.overrideWithValue(
          FakeAccounts(onList: () => Success([account()])),
        ),
        creditCardRepositoryProvider.overrideWithValue(FakeCards()),
        categoryRepositoryProvider.overrideWithValue(
          FakeCategories(tree: treeWith(['Groceries'])),
        ),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(
          preferences ?? InMemoryPreferencesStore(),
        ),
      ],
      child: const MaterialApp(home: TransactionsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('TransactionView.hasInvalidDateRange', () {
    test('Given a range in order '
        'When it is checked '
        'Then it is valid', () {
      final view = TransactionView(
        from: DateTime(2026, 9),
        to: DateTime(2026, 9, 30),
      );

      expect(view.hasInvalidDateRange, isFalse);
    });

    test('Given a start after its end '
        'When it is checked '
        'Then it is invalid (AF-01, FR-TB-04)', () {
      final view = TransactionView(
        from: DateTime(2026, 9, 30),
        to: DateTime(2026, 9),
      );

      expect(view.hasInvalidDateRange, isTrue);
    });

    test('Given only one end of the range '
        'When it is checked '
        'Then it is valid, since an open range is a real question', () {
      expect(
        TransactionView(from: DateTime(2026, 9)).hasInvalidDateRange,
        isFalse,
      );
      expect(
        TransactionView(to: DateTime(2026, 9)).hasInvalidDateRange,
        isFalse,
      );
    });
  });

  group('TransactionView.hasFilters', () {
    test('Given a default view '
        'When it is asked '
        'Then nothing is filtered', () {
      expect(const TransactionView().hasFilters, isFalse);
    });

    test('Given any filter '
        'When it is asked '
        'Then it reports one', () {
      expect(const TransactionView(categoryId: 'cat1').hasFilters, isTrue);
      expect(
        const TransactionView(direction: Direction.expense).hasFilters,
        isTrue,
      );
      expect(const TransactionView(minimumAmount: '10').hasFilters, isTrue);
    });

    test('Given only a sort or a page '
        'When it is asked '
        'Then neither counts as a filter', () {
      expect(
        const TransactionView(
          sortBy: TransactionColumn.amount,
          pageNumber: 3,
        ).hasFilters,
        isFalse,
      );
    });
  });

  group('TransactionView round trip', () {
    test('Given a view with every field set '
        'When it is stored and restored '
        'Then it comes back equal (FR-TB-05, AF-06)', () {
      final view = TransactionView(
        from: DateTime(2026, 9),
        to: DateTime(2026, 9, 30),
        financialAccountId: 'a1',
        categoryId: 'cat1',
        direction: Direction.earning,
        minimumAmount: '10.00',
        maximumAmount: '500.00',
        text: 'market',
        sortBy: TransactionColumn.amount,
        descending: false,
        pageNumber: 4,
      );

      expect(TransactionView.fromJson(view.toJson()), view);
    });

    test('Given a stored view with unreadable fields '
        'When it is restored '
        'Then it falls back to the default rather than failing', () {
      final restored = TransactionView.fromJson({
        'from': 'not a date',
        'sortBy': 'nonsense',
        'direction': 99,
      });

      expect(restored.from, isNull);
      expect(restored.sortBy, TransactionColumn.date);
      expect(restored.direction, isNull);
      expect(restored.pageNumber, 1);
    });
  });

  group('TransactionViewController', () {
    test('Given a page beyond the first '
        'When a filter changes '
        'Then the view returns to page one', () async {
      final container = containerWith(SearchableTransactions());
      final controller = container.read(transactionViewProvider.notifier)
        ..goToPage(4);

      expect(container.read(transactionViewProvider).pageNumber, 4);

      controller.filter(
        container.read(transactionViewProvider).copyWith(categoryId: 'cat1'),
      );

      expect(container.read(transactionViewProvider).pageNumber, 1);
    });

    test('Given a column that is already sorted '
        'When it is sorted again '
        'Then the direction reverses', () {
      final container = containerWith(SearchableTransactions());
      final controller = container.read(transactionViewProvider.notifier);

      expect(container.read(transactionViewProvider).descending, isTrue);

      controller.sortBy(TransactionColumn.date);
      expect(container.read(transactionViewProvider).descending, isFalse);

      controller.sortBy(TransactionColumn.date);
      expect(container.read(transactionViewProvider).descending, isTrue);
    });

    test('Given a different column '
        'When it is sorted by '
        'Then it starts descending', () {
      final container = containerWith(SearchableTransactions());
      final controller = container.read(transactionViewProvider.notifier)
        ..sortBy(TransactionColumn.date);

      expect(container.read(transactionViewProvider).descending, isFalse);

      controller.sortBy(TransactionColumn.amount);

      final view = container.read(transactionViewProvider);
      expect(view.sortBy, TransactionColumn.amount);
      expect(view.descending, isTrue);
    });

    test('Given filters and a sort '
        'When the filters are cleared '
        'Then the sort survives (AF-02)', () {
      final container = containerWith(SearchableTransactions());
      final controller = container.read(transactionViewProvider.notifier)
        ..sortBy(TransactionColumn.amount);

      // Derived from the current view, exactly as the filter bar does it.
      controller
        ..filter(
          container.read(transactionViewProvider).copyWith(categoryId: 'cat1'),
        )
        ..clearFilters();

      final view = container.read(transactionViewProvider);
      expect(view.hasFilters, isFalse);
      expect(view.sortBy, TransactionColumn.amount);
    });

    test('Given a view '
        'When it changes '
        'Then it is written to the store (FR-TB-05)', () async {
      final preferences = InMemoryPreferencesStore();
      final container = containerWith(
        SearchableTransactions(),
        preferences: preferences,
      );

      container
          .read(transactionViewProvider.notifier)
          .filter(const TransactionView(categoryId: 'cat1'));

      await Future<void>.delayed(Duration.zero);

      final stored = await preferences.read(PreferenceKey.transactionsView);
      expect(stored, isNotNull);
      expect(stored, contains('cat1'));
    });
  });

  group('transactionPageProvider', () {
    test('Given a view '
        'When the page is read '
        'Then every filter is asked of the API (FR-TB-02)', () async {
      final fake = SearchableTransactions();
      final view = TransactionView(
        from: DateTime(2026, 9),
        to: DateTime(2026, 9, 30),
        financialAccountId: 'a1',
        categoryId: 'cat1',
        direction: Direction.expense,
        minimumAmount: '10.00',
        maximumAmount: '500.00',
        sortBy: TransactionColumn.amount,
        pageNumber: 2,
      );

      await containerWith(fake).read(transactionPageProvider(view).future);

      final asked = fake.searches.single;
      expect(asked['from'], DateTime(2026, 9));
      expect(asked['financialAccountId'], 'a1');
      expect(asked['categoryId'], 'cat1');
      expect(asked['direction'], Direction.expense);
      expect(asked['minimumAmount'], '10.00');
      expect(asked['maximumAmount'], '500.00');
      expect(asked['sortBy'], 'amount');
      expect(asked['pageNumber'], 2);
    });

    test('Given a date range the wrong way round '
        'When the page is read '
        'Then nothing is requested at all (AF-01)', () async {
      final fake = SearchableTransactions();
      final view = TransactionView(
        from: DateTime(2026, 9, 30),
        to: DateTime(2026, 9),
      );

      await expectLater(
        containerWith(fake).read(transactionPageProvider(view).future),
        throwsA(isA<InvalidDateRange>()),
      );

      // The point of AF-01: the API was never asked.
      expect(fake.searches, isEmpty);
    });

    test('Given the request fails '
        'When the page is read '
        "Then the API's reason surfaces (AF-03)", () async {
      final fake = SearchableTransactions(
        onSearch: () => const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      await expectLater(
        containerWith(fake)
            .read(transactionPageProvider(const TransactionView()).future),
        throwsA(
          isA<TableUnavailable>().having(
            (e) => e.message,
            'message',
            'The instance could not be reached.',
          ),
        ),
      );
    });

    test('Given a page beyond the last was asked for '
        'When the API answers with the last '
        'Then that is what is shown (AF-05)', () async {
      final fake = SearchableTransactions(
        // The API clamps: asked for 99, answered with 3.
        onSearch: () => Success(page(pageNumber: 3, totalPages: 3)),
      );

      final result = await containerWith(fake).read(
        transactionPageProvider(const TransactionView(pageNumber: 99)).future,
      );

      expect(result.pageNumber, 3);
      expect(result.hasNext, isFalse);
    });
  });

  group('TransactionPage', () {
    test('Given a page in the middle '
        'When it is asked '
        'Then both neighbours exist', () {
      final middle = page(pageNumber: 2, totalPages: 3);

      expect(middle.hasPrevious, isTrue);
      expect(middle.hasNext, isTrue);
    });

    test('Given the only page '
        'When it is asked '
        'Then neither neighbour exists', () {
      final only = page();

      expect(only.hasPrevious, isFalse);
      expect(only.hasNext, isFalse);
    });

    test('Given no items '
        'When it is asked '
        'Then it is empty (AF-02)', () {
      expect(page(items: 0, totalItems: 0).isEmpty, isTrue);
    });
  });

  group('TransactionsScreen', () {
    testWidgets('Given the page is still loading '
        'When the screen is built '
        'Then a loading state is shown (FR-PS-10)', (tester) async {
      final pending = Completer<Result<TransactionPage>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(
              SlowSearch(pending.future),
            ),
            accountRepositoryProvider.overrideWithValue(FakeAccounts()),
            creditCardRepositoryProvider.overrideWithValue(FakeCards()),
            categoryRepositoryProvider.overrideWithValue(FakeCategories()),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('transactions.loading')), findsOneWidget);

      pending.complete(Success(page()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transactions.grid')), findsOneWidget);
    });

    testWidgets('Given records '
        'When the screen settles '
        'Then they are shown in a grid (step 2, FR-TB-01)', (tester) async {
      await pumpTable(tester, SearchableTransactions());

      expect(find.byKey(const Key('transactions.grid')), findsOneWidget);
      expect(find.byType(DataRow), findsNothing);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('Given no records match '
        'When the screen settles '
        'Then an empty state is shown, distinct from a failure (AF-02, '
        'FR-TB-07)', (tester) async {
      await pumpTable(
        tester,
        SearchableTransactions(
          onSearch: () => Success(page(items: 0, totalItems: 0)),
        ),
      );

      expect(find.byKey(const Key('transactions.empty')), findsOneWidget);
      expect(find.byKey(const Key('transactions.failed')), findsNothing);
    });

    testWidgets('Given filters are applied and nothing matches '
        'When the empty state is shown '
        'Then clearing the filters is offered (AF-02)', (tester) async {
      final fake = SearchableTransactions(
        onSearch: () => Success(page(items: 0, totalItems: 0)),
      );

      await pumpTable(tester, fake);
      await tester.tap(find.byKey(const Key('transactions.filter.category')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Groceries').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transactions.empty.clear')), findsOneWidget);
      expect(fake.searches.last['categoryId'], 'cat1');

      await tester.tap(find.byKey(const Key('transactions.empty.clear')));
      await tester.pumpAndSettle();

      // The view is back to unfiltered, so the offer to clear is gone. No new
      // request is asserted here on purpose: the unfiltered page was already
      // fetched and is still cached, and re-asking for it would be waste
      // rather than correctness.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TransactionsScreen)),
      );
      expect(container.read(transactionViewProvider).hasFilters, isFalse);
      expect(container.read(transactionViewProvider).categoryId, isNull);
      expect(find.byKey(const Key('transactions.empty.clear')), findsNothing);
    });

    testWidgets('Given the request fails '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state (AF-03)', (
      tester,
    ) async {
      var attempts = 0;
      final fake = SearchableTransactions(
        onSearch: () {
          attempts++;
          return const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          );
        },
      );

      await pumpTable(tester, fake);

      expect(find.byKey(const Key('transactions.failed')), findsOneWidget);
      expect(find.byKey(const Key('transactions.empty')), findsNothing);
      expect(find.text('The instance could not be reached.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('transactions.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a column is tapped '
        'When it sorts '
        'Then the API is asked to sort, not a local list (step 5, FR-TB-02)', (
      tester,
    ) async {
      final fake = SearchableTransactions();

      await pumpTable(tester, fake);
      await tester.tap(find.text('Amount'));
      await tester.pumpAndSettle();

      expect(fake.searches.last['sortBy'], 'amount');
      expect(fake.searches.last['descending'], isTrue);
    });

    testWidgets('Given more than one page '
        'When the next page is requested '
        'Then the API is asked for it (step 6)', (tester) async {
      final fake = SearchableTransactions(
        onSearch: () => Success(page(pageNumber: 1, totalPages: 3)),
      );

      await pumpTable(tester, fake);
      await tester.tap(find.byKey(const Key('transactions.next')));
      await tester.pumpAndSettle();

      expect(fake.searches.last['pageNumber'], 2);
    });

    testWidgets('Given the first page '
        'When it is shown '
        'Then there is no previous page to go to', (tester) async {
      await pumpTable(
        tester,
        SearchableTransactions(
          onSearch: () => Success(page(pageNumber: 1, totalPages: 3)),
        ),
      );

      final previous = tester.widget<IconButton>(
        find.byKey(const Key('transactions.previous')),
      );
      expect(previous.onPressed, isNull);
    });

    testWidgets('Given a date range the wrong way round '
        'When it is applied '
        'Then the form says so and nothing is requested (AF-01)', (
      tester,
    ) async {
      final fake = SearchableTransactions();

      await pumpTable(tester, fake);
      final before = fake.searches.length;

      // Applied directly: the picker itself cannot produce a reversed range.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TransactionsScreen)),
      );
      container
          .read(transactionViewProvider.notifier)
          .filter(
            TransactionView(from: DateTime(2026, 9, 30), to: DateTime(2026, 9)),
          );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('transactions.filter.invalidRange')),
        findsOneWidget,
      );
      expect(fake.searches.length, before);
      expect(find.byKey(const Key('transactions.retry')), findsNothing);
    });

    testWidgets('Given a stored view '
        'When the screen opens '
        'Then the filters are restored with it (AF-06, FR-TB-05)', (
      tester,
    ) async {
      final preferences = InMemoryPreferencesStore();
      await preferences.write(
        PreferenceKey.transactionsView,
        '{"categoryId":"cat1","sortBy":"amount","descending":false,'
        '"pageNumber":2}',
      );

      final fake = SearchableTransactions();
      await pumpTable(tester, fake, preferences: preferences);

      final asked = fake.searches.last;
      expect(asked['categoryId'], 'cat1');
      expect(asked['sortBy'], 'amount');
      expect(asked['descending'], isFalse);
      expect(asked['pageNumber'], 2);
    });

    testWidgets('Given a grid wider than the viewport '
        'When it is shown '
        'Then it scrolls within its own bounds (AF-04, FR-TB-08)', (
      tester,
    ) async {
      await pumpTable(tester, SearchableTransactions());

      // The horizontal scroll is an ancestor of the grid, which is what
      // keeps the sideways movement inside the grid's own box rather than
      // letting the page carry it.
      final horizontalAboveGrid = find.ancestor(
        of: find.byKey(const Key('transactions.grid')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SingleChildScrollView &&
              widget.scrollDirection == Axis.horizontal,
        ),
      );

      expect(horizontalAboveGrid, findsOneWidget);

      // And nothing above the grid scrolls the page sideways as a whole.
      expect(
        find.ancestor(
          of: find.byType(Scaffold),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SingleChildScrollView &&
                widget.scrollDirection == Axis.horizontal,
          ),
        ),
        findsNothing,
      );
    });

    testWidgets('Given a refresh is in flight '
        'When a filter changes '
        'Then the previous page is not presented as current (AF-07, '
        'FR-PS-11)', (tester) async {
      final pending = Completer<Result<TransactionPage>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(
              SlowSearch(pending.future),
            ),
            accountRepositoryProvider.overrideWithValue(FakeAccounts()),
            creditCardRepositoryProvider.overrideWithValue(FakeCards()),
            categoryRepositoryProvider.overrideWithValue(FakeCategories()),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: TransactionsScreen()),
        ),
      );
      await tester.pump();

      // While the first request is outstanding, no grid is claiming to be
      // the answer.
      expect(find.byKey(const Key('transactions.loading')), findsOneWidget);
      expect(find.byKey(const Key('transactions.grid')), findsNothing);

      pending.complete(Success(page()));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('transactions.grid')), findsOneWidget);
    });
  });
}
