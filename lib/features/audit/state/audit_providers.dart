/// Audit trail state (UC-41).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/paging.dart';
import '../../../core/result/result.dart';
import '../data/audit_repository.dart';

/// What the trail is currently filtered to.
final auditFilterProvider =
    NotifierProvider<AuditFilterController, AuditFilter>(
      AuditFilterController.new,
    );

class AuditFilterController extends Notifier<AuditFilter> {
  @override
  AuditFilter build() => const AuditFilter();

  // Sets the whole period: a bound left out is no bound, not the old one.
  // Every filter change starts again at page 1: page 3 of the old filter
  // means nothing under the new one.
  void setPeriod({DateTime? from, DateTime? to}) => state = state.copyWith(
    from: from,
    to: to,
    clearFrom: from == null,
    clearTo: to == null,
    pageNumber: 1,
  );

  void setOperation(String? operation) => state = operation == null
      ? state.copyWith(clearOperation: true, pageNumber: 1)
      : state.copyWith(operation: operation, pageNumber: 1);

  void goToPage(int pageNumber) =>
      state = state.copyWith(pageNumber: pageNumber < 1 ? 1 : pageNumber);

  void clear() => state = const AuditFilter();
}

/// The page of entries the current filter asks for.
final auditEntriesProvider = FutureProvider<PagedList<AuditEntry>>(
  retry: (retryCount, error) => null,
  (ref) async {
    final filter = ref.watch(auditFilterProvider);
    final result = await ref.read(auditRepositoryProvider).read(filter);

    return switch (result) {
      Success<PagedList<AuditEntry>>(:final value) => value,
      Failure<PagedList<AuditEntry>>(:final message) => throw AuditUnavailable(
        message,
      ),
    };
  },
);

class AuditUnavailable implements Exception {
  const AuditUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}
