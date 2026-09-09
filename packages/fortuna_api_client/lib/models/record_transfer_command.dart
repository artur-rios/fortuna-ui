// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_transfer_command.g.dart';

@JsonSerializable()
class RecordTransferCommand {
  const RecordTransferCommand({
    this.amount,
    this.destinationFinancialAccountId,
    this.destinationStatementId,
    this.occurredOn,
    this.originFinancialAccountId,
    this.ownerId,
  });

  factory RecordTransferCommand.fromJson(Map<String, Object?> json) =>
      _$RecordTransferCommandFromJson(json);

  final double? amount;
  final String? destinationFinancialAccountId;
  final String? destinationStatementId;
  final DateTime? occurredOn;
  final String? originFinancialAccountId;
  final String? ownerId;

  Map<String, Object?> toJson() => _$RecordTransferCommandToJson(this);
}
