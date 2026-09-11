/// The raw records an import took in (UC-34).
///
/// `FR-IN-14` asks for the records **as the API stored them**, which is why
/// this repository offers no way to change one. A raw record is the evidence
/// an import is reconciled against; a record that could be edited would be
/// evidence of nothing, and the correction the user actually wants belongs on
/// the transaction derived from it (`AF-01`).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What became of a record the import read.
///
/// Mapped from the contract's numbers for the reason `AccountType` gives. The
/// three are kept apart because `AF-02` needs them apart: "already here" and
/// "could not be used" are different facts, and collapsing them into "no
/// transaction" would tell the user nothing they can act on.
enum RecordOutcome {
  imported(1, 'Imported'),
  duplicate(2, 'Already present'),
  rejected(3, 'Rejected'),

  /// An outcome this build does not recognize, named rather than assumed.
  unknown(0, 'Unknown');

  const RecordOutcome(this.wire, this.label);

  final int wire;
  final String label;

  static RecordOutcome from(ImportedRecordOutcome? outcome) =>
      switch (outcome?.json) {
        1 => RecordOutcome.imported,
        2 => RecordOutcome.duplicate,
        3 => RecordOutcome.rejected,
        _ => RecordOutcome.unknown,
      };

  /// Whether this outcome should have produced a transaction.
  bool get producedTransaction => this == RecordOutcome.imported;
}

/// One raw record, exactly as the import read it.
@immutable
class ImportedRecord {
  const ImportedRecord({
    required this.outcome,
    required this.hasLiveTransaction,
    this.externalId,
    this.amount,
    this.occurredOn,
    this.rawPayload,
    this.rejectionReason,
    this.transactionId,
  });

  final RecordOutcome outcome;

  /// Whether the transaction this produced still exists.
  ///
  /// Distinct from having a [transactionId]: a record can name a transaction
  /// that has since been deleted, and offering to open one that is gone would
  /// be worse than saying it is not there.
  final bool hasLiveTransaction;

  /// The institution's or file's own identifier for the row.
  final String? externalId;

  /// What the record said, before anything was derived from it.
  ///
  /// Kept as the text it arrived as, not as a [Money]. The contract gives a
  /// raw record no currency — it is a row from a file, not an amount the
  /// system owns — and wrapping it in a currency-less `Money` would invent a
  /// denomination nobody supplied. Shown verbatim for the same reason the
  /// payload is.
  final String? amount;

  final DateTime? occurredOn;

  /// The row as it arrived. Shown verbatim, never parsed for display.
  final String? rawPayload;

  /// `AF-02`: why nothing was derived, in the API's words.
  final String? rejectionReason;

  final String? transactionId;

  /// Whether a derived transaction can actually be opened (step 3).
  bool get canOpenTransaction =>
      hasLiveTransaction && (transactionId?.isNotEmpty ?? false);

  /// `AF-02`: the record produced nothing, and there is a reason to show.
  bool get producedNothing => !outcome.producedTransaction;
}

/// One page of a job's records.
@immutable
class ImportedRecordPage {
  const ImportedRecordPage({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
  });

  final List<ImportedRecord> items;
  final int pageNumber;
  final int totalPages;

  /// `AF-03`.
  bool get isEmpty => items.isEmpty;

  bool get hasPrevious => pageNumber > 1;
  bool get hasNext => pageNumber < totalPages;
}

abstract interface class ImportedRecordRepository {
  /// Reads a page of the records a job took in.
  ///
  /// There is deliberately no write on this interface. `AF-01` is not a rule
  /// the screen enforces politely — it is a capability this client does not
  /// have.
  Future<Result<ImportedRecordPage>> forJob(
    String jobId, {
    int pageNumber,
    int pageSize,
  });
}

class HttpImportedRecordRepository implements ImportedRecordRepository {
  HttpImportedRecordRepository(this._client);

  factory HttpImportedRecordRepository.fromDio(Dio dio) =>
      HttpImportedRecordRepository(ImportJobsClient(dio));

  final ImportJobsClient _client;

  @override
  Future<Result<ImportedRecordPage>> forJob(
    String jobId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final output = await _client.getApiImportJobsIdRecords(
        id: jobId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      return Success(
        ImportedRecordPage(
          items: [
            for (final record in output.data ?? const <ImportedRecordOutput>[])
              _from(record),
          ],
          pageNumber: output.pageNumber ?? pageNumber,
          totalPages: output.totalPages ?? 0,
        ),
      );
    } on DioException catch (exception) {
      // AF-04: a job that is not yours reads as not found, as the API intends.
      return failureFromDioException<ImportedRecordPage>(exception);
    }
  }

  static ImportedRecord _from(ImportedRecordOutput output) => ImportedRecord(
    outcome: RecordOutcome.from(output.outcome),
    hasLiveTransaction: output.hasLiveTransaction ?? false,
    externalId: output.externalId,
    amount: output.amount,
    occurredOn: output.occurredOn,
    rawPayload: output.rawPayload,
    rejectionReason: output.rejectionReason,
    transactionId: output.transactionId,
  );
}

final importedRecordRepositoryProvider = Provider<ImportedRecordRepository>(
  (ref) => HttpImportedRecordRepository.fromDio(ref.watch(dioProvider)),
);
