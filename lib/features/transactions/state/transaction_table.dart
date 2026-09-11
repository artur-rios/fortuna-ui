/// The spreadsheet view's state (UC-25).
///
/// Everything the grid shows is a question asked of the API (`FR-TB-02`).
/// There is deliberately no cached full set here to filter or sort against —
/// that is what keeps the view usable on a history too large to hold in
/// memory, and it is why [TransactionView] describes a *request* rather than
/// a result.
///
/// The view survives navigation and reload (`FR-TB-05`, `AF-06`) by being
/// written to the preferences store. It is a presentation choice — which
/// slice of their own records the user is looking at — so it belongs there
/// rather than in secure storage.
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/config/instance_config.dart';
import '../../../core/result/result.dart';
import '../../../core/storage/preferences_store.dart';
import '../../insight/data/export_repository.dart';
import '../data/transaction_repository.dart';

/// How many records a page holds.
const transactionPageSize = 25;

/// The columns the grid can be sorted by, and what the API calls each.
enum TransactionColumn {
  date('occurredOn', 'Date'),
  amount('amount', 'Amount'),
  category('categoryName', 'Category'),
  holding('financialAccountName', 'Account or card'),
  description('description', 'Description');

  const TransactionColumn(this.wireName, this.label);

  /// What the API sorts by. Sorting is the instance's to perform
  /// (`FR-TB-02`), so this is a name it recognizes rather than a local
  /// comparator.
  final String wireName;

  final String label;

  static TransactionColumn? byWireName(String? name) {
    for (final column in TransactionColumn.values) {
      if (column.wireName == name) return column;
    }
    return null;
  }
}

/// What the grid is currently asking for.
@immutable
class TransactionView {
  const TransactionView({
    this.from,
    this.to,
    this.financialAccountId,
    this.creditCardId,
    this.categoryId,
    this.tagId,
    this.counterpartyId,
    this.direction,
    this.minimumAmount,
    this.maximumAmount,
    this.text,
    this.sortBy = TransactionColumn.date,
    this.descending = true,
    this.pageNumber = 1,
  });

  final DateTime? from;
  final DateTime? to;
  final String? financialAccountId;
  final String? creditCardId;
  final String? categoryId;
  final String? tagId;
  final String? counterpartyId;
  final Direction? direction;

  /// Amount bounds as typed strings, never parsed to a number here — the API
  /// compares them, and this client only carries them.
  final String? minimumAmount;
  final String? maximumAmount;

  final String? text;

  final TransactionColumn sortBy;
  final bool descending;
  final int pageNumber;

  /// Whether the date range is the wrong way round (`FR-TB-04`, `AF-01`).
  ///
  /// Asked before anything is requested, because a range nobody could satisfy
  /// is not a query worth sending.
  bool get hasInvalidDateRange {
    final start = from;
    final end = to;

    if (start == null || end == null) return false;
    return start.isAfter(end);
  }

  /// Whether any filter is narrowing the set, which is what `AF-02` offers to
  /// clear.
  bool get hasFilters =>
      from != null ||
      to != null ||
      financialAccountId != null ||
      creditCardId != null ||
      categoryId != null ||
      tagId != null ||
      counterpartyId != null ||
      direction != null ||
      (minimumAmount?.isNotEmpty ?? false) ||
      (maximumAmount?.isNotEmpty ?? false) ||
      (text?.isNotEmpty ?? false);

  /// A copy with the given changes.
  ///
  /// Every filter change resets to the first page: page 4 of an old filter is
  /// meaningless under a new one, and silently keeping it is how a user ends
  /// up looking at an empty page and concluding they have no records.
  TransactionView copyWith({
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
    TransactionColumn? sortBy,
    bool? descending,
    int? pageNumber,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearAccount = false,
    bool clearCategory = false,
    bool clearDirection = false,
  }) => TransactionView(
    from: clearFrom ? null : (from ?? this.from),
    to: clearTo ? null : (to ?? this.to),
    financialAccountId: clearAccount
        ? null
        : (financialAccountId ?? this.financialAccountId),
    creditCardId: clearAccount ? null : (creditCardId ?? this.creditCardId),
    categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
    tagId: tagId ?? this.tagId,
    counterpartyId: counterpartyId ?? this.counterpartyId,
    direction: clearDirection ? null : (direction ?? this.direction),
    minimumAmount: minimumAmount ?? this.minimumAmount,
    maximumAmount: maximumAmount ?? this.maximumAmount,
    text: text ?? this.text,
    sortBy: sortBy ?? this.sortBy,
    descending: descending ?? this.descending,
    pageNumber: pageNumber ?? this.pageNumber,
  );

  Map<String, Object?> toJson() => {
    'from': from?.toIso8601String(),
    'to': to?.toIso8601String(),
    'financialAccountId': financialAccountId,
    'creditCardId': creditCardId,
    'categoryId': categoryId,
    'tagId': tagId,
    'counterpartyId': counterpartyId,
    'direction': direction?.wire,
    'minimumAmount': minimumAmount,
    'maximumAmount': maximumAmount,
    'text': text,
    'sortBy': sortBy.wireName,
    'descending': descending,
    'pageNumber': pageNumber,
  };

  /// Restores a stored view, ignoring anything it cannot read.
  ///
  /// A malformed stored view falls back to the default rather than throwing:
  /// a preference that has gone stale should cost the user a filter, not the
  /// screen.
  static TransactionView fromJson(Map<String, Object?> json) {
    DateTime? date(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;
    String? text(Object? value) =>
        value is String && value.isNotEmpty ? value : null;

    return TransactionView(
      from: date(json['from']),
      to: date(json['to']),
      financialAccountId: text(json['financialAccountId']),
      creditCardId: text(json['creditCardId']),
      categoryId: text(json['categoryId']),
      tagId: text(json['tagId']),
      counterpartyId: text(json['counterpartyId']),
      direction: switch (json['direction']) {
        2 => Direction.earning,
        1 => Direction.expense,
        _ => null,
      },
      minimumAmount: text(json['minimumAmount']),
      maximumAmount: text(json['maximumAmount']),
      text: text(json['text']),
      sortBy:
          TransactionColumn.byWireName(json['sortBy'] as String?) ??
          TransactionColumn.date,
      descending: json['descending'] as bool? ?? true,
      pageNumber: json['pageNumber'] as int? ?? 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TransactionView &&
      other.from == from &&
      other.to == to &&
      other.financialAccountId == financialAccountId &&
      other.creditCardId == creditCardId &&
      other.categoryId == categoryId &&
      other.tagId == tagId &&
      other.counterpartyId == counterpartyId &&
      other.direction == direction &&
      other.minimumAmount == minimumAmount &&
      other.maximumAmount == maximumAmount &&
      other.text == text &&
      other.sortBy == sortBy &&
      other.descending == descending &&
      other.pageNumber == pageNumber;

  @override
  int get hashCode => Object.hash(
    from,
    to,
    financialAccountId,
    creditCardId,
    categoryId,
    tagId,
    counterpartyId,
    direction,
    minimumAmount,
    maximumAmount,
    Object.hash(text, sortBy, descending, pageNumber),
  );
}

/// Holds the view and writes every change through to storage.
class TransactionViewController extends Notifier<TransactionView> {
  @override
  TransactionView build() {
    // Restored asynchronously: the grid opens on the default view and moves
    // to the stored one as soon as it is read, which is quicker than holding
    // the whole screen behind a preference lookup.
    ref.read(transactionViewStoreProvider).read().then((restored) {
      if (restored != null) state = restored;
    });

    return const TransactionView();
  }

  void update(TransactionView view) {
    state = view;
    // Fire and forget: a preference that fails to save costs the user a
    // restored filter, which is not worth blocking the grid for.
    ref.read(transactionViewStoreProvider).write(view).ignore();
  }

  /// Applies a filter change, returning to the first page.
  void filter(TransactionView view) => update(view.copyWith(pageNumber: 1));

  /// Sorts by [column] (`FR-TB-02`: the API sorts, not this client).
  ///
  /// Tapping the sorted column reverses it; tapping another sorts by it
  /// descending, which is what a reader scanning for the largest or most
  /// recent wants first.
  void sortBy(TransactionColumn column) => update(
    state.copyWith(
      sortBy: column,
      descending: state.sortBy == column ? !state.descending : true,
      pageNumber: 1,
    ),
  );

  void goToPage(int pageNumber) =>
      update(state.copyWith(pageNumber: pageNumber < 1 ? 1 : pageNumber));

  /// `AF-02`: clears every filter, keeping the sort.
  void clearFilters() => update(
    TransactionView(sortBy: state.sortBy, descending: state.descending),
  );
}

final transactionViewProvider =
    NotifierProvider<TransactionViewController, TransactionView>(
      TransactionViewController.new,
    );

/// Reads and writes the stored view (`FR-TB-05`, `AF-06`).
class TransactionViewStore {
  const TransactionViewStore(this._preferences);

  final PreferencesStore _preferences;

  Future<TransactionView?> read() async {
    final stored = await _preferences.read(PreferenceKey.transactionsView);
    if (stored == null || stored.isEmpty) return null;

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! Map<String, Object?>) return null;
      return TransactionView.fromJson(decoded);
    } on FormatException {
      // A stored view that cannot be read is discarded rather than raised.
      return null;
    }
  }

  Future<void> write(TransactionView view) => _preferences.write(
    PreferenceKey.transactionsView,
    jsonEncode(view.toJson()),
  );
}

final transactionViewStoreProvider = Provider<TransactionViewStore>(
  (ref) => TransactionViewStore(ref.watch(preferencesStoreProvider)),
);

/// The page the current view asks for.
///
/// Keyed on the view itself, so changing a filter is a different request
/// rather than a mutation of this one — which is what makes `AF-07` fall out
/// naturally: a new view starts in the loading state instead of holding the
/// previous page while it waits.
final transactionPageProvider =
    FutureProvider.family<TransactionPage, TransactionView>(
      retry: (retryCount, error) => null,
      (ref, view) async {
        // AF-01: a range nobody could satisfy is not asked.
        if (view.hasInvalidDateRange) {
          throw const InvalidDateRange();
        }

        final result = await ref
            .read(transactionRepositoryProvider)
            .search(
              from: view.from,
              to: view.to,
              financialAccountId: view.financialAccountId,
              creditCardId: view.creditCardId,
              categoryId: view.categoryId,
              tagId: view.tagId,
              counterpartyId: view.counterpartyId,
              direction: view.direction,
              minimumAmount: view.minimumAmount,
              maximumAmount: view.maximumAmount,
              text: view.text,
              sortBy: view.sortBy.wireName,
              descending: view.descending,
              pageNumber: view.pageNumber,
              pageSize: transactionPageSize,
            );

        return switch (result) {
          Success<TransactionPage>(:final value) => value,
          // AF-03.
          Failure<TransactionPage>(:final message) => throw TableUnavailable(
            message,
          ),
        };
      },
    );

/// `AF-01`, raised before any request is made.
class InvalidDateRange implements Exception {
  const InvalidDateRange();

  @override
  String toString() =>
      'The start of the range is after its end. Nothing was requested.';
}

class TableUnavailable implements Exception {
  const TableUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The view's filters, described as the user reads them (`FR-EX-03`).
///
/// Lives here rather than in the export sheet because the wording has to come
/// from whatever knows what the filter means. An export that said
/// `categoryId=cat1` would be technically accurate and useless: step 2 exists
/// so the user can check the scope, and a scope stated in identifiers cannot
/// be checked.
List<ExportFilter> describeFilters(TransactionView view) {
  final described = <ExportFilter>[];

  void add(String field, String operator, String value, String description) =>
      described.add(
        ExportFilter(
          field: field,
          operator: operator,
          value: value,
          description: description,
        ),
      );

  if (view.from case final from?) {
    add('occurredOn', 'gte', from.toIso8601String(), 'From ${_day(from)}');
  }
  if (view.to case final to?) {
    add('occurredOn', 'lte', to.toIso8601String(), 'Up to ${_day(to)}');
  }
  if (view.financialAccountId case final id?) {
    add('financialAccountId', 'eq', id, 'One account only');
  }
  if (view.creditCardId case final id?) {
    add('creditCardId', 'eq', id, 'One card only');
  }
  if (view.categoryId case final id?) {
    add('categoryId', 'eq', id, 'One category only');
  }
  if (view.tagId case final id?) {
    add('tagId', 'eq', id, 'One tag only');
  }
  if (view.counterpartyId case final id?) {
    add('counterpartyId', 'eq', id, 'One counterparty only');
  }
  if (view.direction case final direction?) {
    add('direction', 'eq', '${direction.wire}', '${direction.label}s only');
  }
  if (view.minimumAmount case final minimum? when minimum.isNotEmpty) {
    add('amount', 'gte', minimum, 'At least $minimum');
  }
  if (view.maximumAmount case final maximum? when maximum.isNotEmpty) {
    add('amount', 'lte', maximum, 'At most $maximum');
  }
  if (view.text case final text? when text.isNotEmpty) {
    add('text', 'contains', text, 'Matching "$text"');
  }

  return described;
}

String _day(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
