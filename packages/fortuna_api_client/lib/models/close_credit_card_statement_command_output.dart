// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'close_credit_card_statement_command_output.g.dart';

@JsonSerializable()
class CloseCreditCardStatementCommandOutput {
  const CloseCreditCardStatementCommandOutput({
    this.amountDue,
    this.closingDate,
    this.creditCardId,
    this.dueDate,
    this.id,
    this.periodEnd,
    this.periodStart,
    this.purchaseTotal,
    this.status,
  });

  factory CloseCreditCardStatementCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CloseCreditCardStatementCommandOutputFromJson(json);

  final double? amountDue;
  final DateTime? closingDate;
  final String? creditCardId;
  final DateTime? dueDate;
  final String? id;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final double? purchaseTotal;
  final String? status;

  Map<String, Object?> toJson() =>
      _$CloseCreditCardStatementCommandOutputToJson(this);
}
