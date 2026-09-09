/// The audit trail (UC-41).
///
/// Read-only, and deliberately so: the trail is append-only (`BR-41`), and this
/// repository offers no write of any kind. There is nothing here to edit or
/// delete because there is no such operation to call — `AF-03` is enforced by
/// the shape of this interface, not by a hidden button.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Whether the attempt the entry records went through.
///
/// The trail records **attempts**, not only successes — a refusal is a fact
/// worth keeping, and often the one somebody is looking for.
enum AuditResult {
  succeeded,
  refused,
  unknown;

  static AuditResult from(AuditOutcome? outcome) => switch (outcome) {
    AuditOutcome.value1 => AuditResult.succeeded,
    AuditOutcome.value2 => AuditResult.refused,
    _ => AuditResult.unknown,
  };
}

@immutable
class AuditEntry {
  const AuditEntry({
    required this.occurredAt,
    required this.operation,
    required this.entityType,
    required this.result,
    this.entityId,
    this.reason,
  });

  final DateTime occurredAt;

  /// What was attempted, as the API named it.
  final String operation;

  /// What it was attempted on.
  final String entityType;

  final AuditResult result;

  /// The record the entry is about.
  ///
  /// `AF-04`: the record may be long gone. The entry still says what it
  /// recorded, and this identifier is shown as a reference rather than as a
  /// link that would imply the record is still there to open.
  final String? entityId;

  /// Why it was refused, where the API gave a reason.
  final String? reason;
}

/// What the trail is filtered to (`step 3`).
@immutable
class AuditFilter {
  const AuditFilter({this.from, this.to, this.operation});

  final DateTime? from;
  final DateTime? to;

  /// The kind of action, as the API names it.
  final String? operation;

  bool get isEmpty => from == null && to == null && operation == null;

  AuditFilter copyWith({
    DateTime? from,
    DateTime? to,
    String? operation,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearOperation = false,
  }) => AuditFilter(
    from: clearFrom ? null : from ?? this.from,
    to: clearTo ? null : to ?? this.to,
    operation: clearOperation ? null : operation ?? this.operation,
  );
}

abstract interface class AuditRepository {
  Future<Result<List<AuditEntry>>> read(AuditFilter filter);
}

class HttpAuditRepository implements AuditRepository {
  HttpAuditRepository(this._client);

  factory HttpAuditRepository.fromDio(Dio dio) =>
      HttpAuditRepository(AuditEntriesClient(dio));

  final AuditEntriesClient _client;

  @override
  Future<Result<List<AuditEntry>>> read(AuditFilter filter) async {
    try {
      final response = await _client.getApiAuditEntries(
        from: filter.from,
        to: filter.to,
        operation: filter.operation,
      );

      final entries = [
        for (final entry in response.data ?? const <AuditEntryOutput>[])
          AuditEntry(
            occurredAt: entry.occurredAt ?? DateTime.now(),
            operation: entry.operation ?? 'Unknown action',
            entityType: entry.entityType ?? 'Unknown record',
            result: AuditResult.from(entry.outcome),
            entityId: entry.entityId,
            reason: entry.reason,
          ),
      ];

      // Reverse chronological, as step 4 requires. Sorted here rather than
      // trusted: the order a reader depends on should not rest on an
      // undocumented default.
      return Success(
        entries..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)),
      );
    } on DioException catch (exception) {
      return failureFromDioException<List<AuditEntry>>(exception);
    }
  }
}

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => HttpAuditRepository.fromDio(ref.watch(dioProvider)),
);
