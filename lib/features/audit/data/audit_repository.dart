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
import '../../../core/network/paging.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';

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

/// What the trail is filtered to (`step 3`), and which page of it is shown.
///
/// The trail grows with every write and never shrinks (`BR-41`), so it is
/// read a page at a time, the way the transaction grid is (UC-25).
@immutable
class AuditFilter {
  const AuditFilter({this.from, this.to, this.operation, this.pageNumber = 1});

  final DateTime? from;
  final DateTime? to;

  /// The kind of action, as the API names it.
  final String? operation;

  final int pageNumber;

  /// Whether any filter narrows the trail. The page is a position, not a
  /// filter.
  bool get isEmpty => from == null && to == null && operation == null;

  AuditFilter copyWith({
    DateTime? from,
    DateTime? to,
    String? operation,
    int? pageNumber,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearOperation = false,
  }) => AuditFilter(
    from: clearFrom ? null : from ?? this.from,
    to: clearTo ? null : to ?? this.to,
    operation: clearOperation ? null : operation ?? this.operation,
    pageNumber: pageNumber ?? this.pageNumber,
  );

  @override
  bool operator ==(Object other) =>
      other is AuditFilter &&
      other.from == from &&
      other.to == to &&
      other.operation == operation &&
      other.pageNumber == pageNumber;

  @override
  int get hashCode => Object.hash(from, to, operation, pageNumber);
}

abstract interface class AuditRepository {
  /// The page [AuditFilter.pageNumber] of the entries matching [filter].
  Future<Result<PagedList<AuditEntry>>> read(AuditFilter filter);
}

class HttpAuditRepository implements AuditRepository {
  HttpAuditRepository(this._client, {this._clock = systemClock});

  factory HttpAuditRepository.fromDio(Dio dio, {Clock clock = systemClock}) =>
      HttpAuditRepository(AuditEntriesClient(dio), clock: clock);

  final AuditEntriesClient _client;
  final Clock _clock;

  @override
  Future<Result<PagedList<AuditEntry>>> read(AuditFilter filter) async {
    try {
      final page = await _client.getApiAuditEntries(
        from: filter.from,
        to: filter.to,
        operation: filter.operation,
        pageNumber: filter.pageNumber,
        pageSize: browsePageSize,
      );

      final entries = [
        for (final entry in page.data ?? const <AuditEntryOutput>[])
          AuditEntry(
            occurredAt: entry.occurredAt ?? _clock(),
            operation: entry.operation ?? 'Unknown action',
            entityType: entry.entityType ?? 'Unknown record',
            result: AuditResult.from(entry.outcome),
            entityId: entry.entityId,
            reason: entry.reason,
          ),
      ];

      // Reverse chronological, as step 4 requires. The API serves the pages
      // newest first; each page is sorted here as well, so the order a reader
      // depends on does not rest on the page alone.
      return Success(
        PagedList(
          items: entries..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)),
          // AF-05: the page the API answered with.
          pageNumber: page.pageNumber ?? filter.pageNumber,
          totalItems: page.totalItems ?? entries.length,
          totalPages: page.totalPages ?? 1,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<PagedList<AuditEntry>>(exception);
    }
  }
}

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => HttpAuditRepository.fromDio(
    ref.watch(dioProvider),
    clock: ref.watch(clockProvider),
  ),
);
