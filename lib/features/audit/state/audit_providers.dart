/// Audit trail state (UC-41).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void setPeriod({DateTime? from, DateTime? to}) =>
      state = state.copyWith(from: from, to: to);

  void setOperation(String? operation) => state = operation == null
      ? state.copyWith(clearOperation: true)
      : state.copyWith(operation: operation);

  void clear() => state = const AuditFilter();
}

/// The entries matching the current filter.
final auditEntriesProvider = FutureProvider<List<AuditEntry>>(
  retry: (retryCount, error) => null,
  (ref) async {
    final filter = ref.watch(auditFilterProvider);
    final result = await ref.read(auditRepositoryProvider).read(filter);

    return switch (result) {
      Success<List<AuditEntry>>(:final value) => value,
      Failure<List<AuditEntry>>(:final message) => throw AuditUnavailable(
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
