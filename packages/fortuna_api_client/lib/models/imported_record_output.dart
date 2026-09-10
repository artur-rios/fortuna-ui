// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'imported_record_outcome.dart';

part 'imported_record_output.g.dart';

@JsonSerializable()
class ImportedRecordOutput {
  const ImportedRecordOutput({
    this.amount,
    this.externalId,
    this.hasLiveTransaction,
    this.occurredOn,
    this.outcome,
    this.rawPayload,
    this.rejectionReason,
    this.transactionId,
  });

  factory ImportedRecordOutput.fromJson(Map<String, Object?> json) =>
      _$ImportedRecordOutputFromJson(json);

  final String? amount;
  final String? externalId;
  final bool? hasLiveTransaction;
  final DateTime? occurredOn;
  final ImportedRecordOutcome? outcome;
  final String? rawPayload;
  final String? rejectionReason;
  final String? transactionId;

  Map<String, Object?> toJson() => _$ImportedRecordOutputToJson(this);
}
