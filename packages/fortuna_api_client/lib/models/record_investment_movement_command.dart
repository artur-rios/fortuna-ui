// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_movement_type.dart';

part 'record_investment_movement_command.g.dart';

@JsonSerializable()
class RecordInvestmentMovementCommand {
  const RecordInvestmentMovementCommand({
    this.amount,
    this.financialAccountId,
    this.id,
    this.movementType,
    this.occurredOn,
  });

  factory RecordInvestmentMovementCommand.fromJson(Map<String, Object?> json) =>
      _$RecordInvestmentMovementCommandFromJson(json);

  final String? amount;
  final String? financialAccountId;
  final String? id;
  final InvestmentMovementType? movementType;
  final DateTime? occurredOn;

  Map<String, Object?> toJson() =>
      _$RecordInvestmentMovementCommandToJson(this);
}
