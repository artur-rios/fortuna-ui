/// The spreadsheet view (UC-25).
///
/// Four states and nothing between them (`FR-PS-10`): loading, loaded, empty
/// and failed. The empty state is not the failed one — "you have no records
/// matching this" and "we could not ask" are different facts, and a user who
/// cannot tell them apart will either widen a filter that was fine or trust a
/// screen that told them nothing.
///
/// `AF-07` and `FR-PS-11` fall out of how the page is keyed: the request is
/// keyed on the view, so changing a filter is a *different* request rather
/// than a mutation of the current one. The previous page is therefore never
/// shown as though it answered the new question.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/format/supported_locales.dart';
import '../../../shared/widgets/money_text.dart';
import '../../categories/data/category_repository.dart';
import '../../categories/state/category_providers.dart';
import '../../holdings/data/account_repository.dart';
import '../../holdings/state/account_providers.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/transaction_repository.dart';
import '../state/transaction_table.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(transactionViewProvider);
    final page = ref.watch(transactionPageProvider(view));

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('transactions.record'),
        onPressed: () => context.go(Routes.recordTransaction),
        icon: const Icon(Icons.add),
        label: const Text('Record'),
      ),
      // The pager lives here rather than at the bottom of the body so the
      // floating action button cannot sit on top of it. A "next page" control
      // hidden under a "record" button is one mis-tap away from the wrong
      // screen, and `Scaffold` already knows how to keep the two apart.
      bottomNavigationBar: switch (page) {
        AsyncData(value: final value) when !value.isEmpty => _Pagination(
          page: value,
        ),
        _ => null,
      },
      body: Column(
        children: [
          _Filters(view: view),
          const Divider(height: 1),
          Expanded(
            child: page.when(
              loading: () => const Center(
                key: Key('transactions.loading'),
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => _Failed(error: error, view: view),
              data: (value) => value.isEmpty
                  ? _Empty(view: view)
                  : _Grid(page: value, view: view),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 3. Every control writes a new view, and a new view is a new request.
class _Filters extends ConsumerWidget {
  const _Filters({required this.view});

  final TransactionView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(transactionViewProvider.notifier);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    // Whatever has loaded. A filter briefly short of one option beats a bar
    // that refuses to appear until two reads finish.
    final accounts = switch (ref.watch(selectableAccountsProvider)) {
      AsyncData(:final value) => value,
      _ => const <FinancialAccount>[],
    };
    final categories = switch (ref.watch(categoryTreeProvider)) {
      AsyncData(:final value) =>
        value.all.where((category) => !category.isDeleted).toList(),
      _ => const <Category>[],
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                key: const Key('transactions.filter.dates'),
                icon: const Icon(Icons.date_range, size: 18),
                label: Text(
                  view.from == null && view.to == null
                      ? 'Any period'
                      : '${view.from == null ? '…' : dates.format(view.from!)}'
                            ' – '
                            '${view.to == null ? '…' : dates.format(view.to!)}',
                ),
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (range != null) {
                    controller.filter(
                      view.copyWith(from: range.start, to: range.end),
                    );
                  }
                },
              ),

              DropdownButton<String?>(
                key: const Key('transactions.filter.account'),
                value: view.financialAccountId,
                hint: const Text('Any account'),
                items: [
                  const DropdownMenuItem(child: Text('Any account')),
                  for (final account in accounts)
                    DropdownMenuItem(
                      value: account.id,
                      child: Text(account.name),
                    ),
                ],
                onChanged: (value) => controller.filter(
                  value == null
                      ? view.copyWith(clearAccount: true)
                      : view.copyWith(financialAccountId: value),
                ),
              ),

              DropdownButton<String?>(
                key: const Key('transactions.filter.category'),
                value: view.categoryId,
                hint: const Text('Any category'),
                items: [
                  const DropdownMenuItem(child: Text('Any category')),
                  for (final category in categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                ],
                onChanged: (value) => controller.filter(
                  value == null
                      ? view.copyWith(clearCategory: true)
                      : view.copyWith(categoryId: value),
                ),
              ),

              DropdownButton<Direction?>(
                key: const Key('transactions.filter.direction'),
                value: view.direction,
                hint: const Text('Any direction'),
                items: [
                  const DropdownMenuItem(child: Text('Any direction')),
                  for (final direction in Direction.values)
                    DropdownMenuItem(
                      value: direction,
                      child: Text(direction.label),
                    ),
                ],
                onChanged: (value) => controller.filter(
                  value == null
                      ? view.copyWith(clearDirection: true)
                      : view.copyWith(direction: value),
                ),
              ),

              if (view.hasFilters)
                TextButton.icon(
                  key: const Key('transactions.filter.clear'),
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Clear filters'),
                  onPressed: controller.clearFilters,
                ),
            ],
          ),

          // AF-01: said here, where the range was chosen, and nothing is
          // requested until it is fixed.
          if (view.hasInvalidDateRange) ...[
            const SizedBox(height: 8),
            Text(
              'The start of the range is after its end. Nothing was requested.',
              key: const Key('transactions.filter.invalidRange'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

/// AF-03. A reason and a retry, and no stale page beneath it.
class _Failed extends ConsumerWidget {
  const _Failed({required this.error, required this.view});

  final Object error;
  final TransactionView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
    key: const Key('transactions.failed'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$error', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          // A date range the user can fix themselves is not worth a retry
          // button that would ask the same impossible question again.
          if (error is! InvalidDateRange)
            FilledButton(
              key: const Key('transactions.retry'),
              onPressed: () => ref.invalidate(transactionPageProvider(view)),
              child: const Text('Try again'),
            ),
        ],
      ),
    ),
  );
}

/// AF-02. Empty, and visibly not broken.
class _Empty extends ConsumerWidget {
  const _Empty({required this.view});

  final TransactionView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
    key: const Key('transactions.empty'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_outlined, size: 40),
          const SizedBox(height: 16),
          Text(
            view.hasFilters
                ? 'No records match these filters'
                : 'No records yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            view.hasFilters
                ? 'Nothing here matched. The filters may be narrower than you '
                      'meant.'
                : 'Records you enter or import will appear here.',
            textAlign: TextAlign.center,
          ),
          if (view.hasFilters) ...[
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('transactions.empty.clear'),
              onPressed: ref
                  .read(transactionViewProvider.notifier)
                  .clearFilters,
              child: const Text('Clear the filters'),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Steps 2, 5 and 7.
class _Grid extends ConsumerWidget {
  const _Grid({required this.page, required this.view});

  final TransactionPage page;
  final TransactionView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(transactionViewProvider.notifier);
    final locale = SupportedLocales.tagOf(
      ref.watch(preferencesProvider).locale,
    );
    final dates = DateFormat.yMMMd(locale);

    // AF-04 and FR-TB-08: the grid scrolls within its own bounds. The
    // horizontal scroll belongs to this box, so the page itself never moves
    // sideways however wide the columns get.
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            key: const Key('transactions.grid'),
            sortColumnIndex: TransactionColumn.values.indexOf(view.sortBy),
            sortAscending: !view.descending,
            columns: [
              for (final column in TransactionColumn.values)
                DataColumn(
                  label: Text(column.label),
                  // Step 5: the API sorts. Tapping asks it to.
                  onSort: (_, _) => controller.sortBy(column),
                ),
            ],
            rows: [
              for (final transaction in page.items)
                DataRow(
                  key: ValueKey(transaction.id),
                  // Step 7 and FR-TB-06: opening a record leaves the view
                  // untouched, so coming back finds it as it was.
                  onSelectChanged: (_) =>
                      context.go(Routes.transactionOf(transaction.id)),
                  cells: [
                    DataCell(Text(dates.format(transaction.occurredOn))),
                    DataCell(MoneyText(transaction.amount)),
                    DataCell(Text(transaction.categoryName ?? '—')),
                    DataCell(Text(transaction.holdingName ?? '—')),
                    DataCell(
                      Text(
                        transaction.isTransfer
                            ? 'Transfer'
                            : (transaction.description ?? '—'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Step 6.
///
/// A bottom bar rather than the last row of the body, so `Scaffold` keeps the
/// floating action button clear of it. A pager sitting under a "record"
/// button is one mis-tap from the wrong screen.
class _Pagination extends ConsumerWidget {
  const _Pagination({required this.page});

  final TransactionPage page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(transactionViewProvider.notifier);

    return Material(
      elevation: 3,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${page.totalItems} '
                '${page.totalItems == 1 ? 'record' : 'records'}',
                key: const Key('transactions.total'),
              ),
              const Spacer(),
              IconButton(
                key: const Key('transactions.previous'),
                icon: const Icon(Icons.chevron_left),
                onPressed: page.hasPrevious
                    ? () => controller.goToPage(page.pageNumber - 1)
                    : null,
              ),
              Text(
                // The page the API answered with, which after AF-05 is not
                // always the page that was asked for.
                'Page ${page.pageNumber} of ${page.totalPages}',
                key: const Key('transactions.pageNumber'),
              ),
              IconButton(
                key: const Key('transactions.next'),
                icon: const Icon(Icons.chevron_right),
                onPressed: page.hasNext
                    ? () => controller.goToPage(page.pageNumber + 1)
                    : null,
              ),
              // Room for the floating action button, which Scaffold parks
              // just above this bar at its trailing edge.
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
