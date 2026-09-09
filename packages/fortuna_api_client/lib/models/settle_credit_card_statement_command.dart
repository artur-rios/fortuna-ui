// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'settle_credit_card_statement_command.g.dart';

@JsonSerializable()
class SettleCreditCardStatementCommand {
  const SettleCreditCardStatementCommand({
    this.amount,
    this.financialAccountId,
    this.id,
    this.paymentDate,
  });

  factory SettleCreditCardStatementCommand.fromJson(
    Map<String, Object?> json,
  ) => _$SettleCreditCardStatementCommandFromJson(json);

  final double? amount;
  final String? financialAccountId;
  final String? id;
  final DateTime? paymentDate;

  Map<String, Object?> toJson() =>
      _$SettleCreditCardStatementCommandToJson(this);
}
