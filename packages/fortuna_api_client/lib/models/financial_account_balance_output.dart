// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'financial_account_balance_output.g.dart';

@JsonSerializable()
class FinancialAccountBalanceOutput {
  const FinancialAccountBalanceOutput({
    this.asOf,
    this.balance,
    this.currencyCode,
    this.id,
  });

  factory FinancialAccountBalanceOutput.fromJson(Map<String, Object?> json) =>
      _$FinancialAccountBalanceOutputFromJson(json);

  final DateTime? asOf;
  final double? balance;
  final String? currencyCode;
  final String? id;

  Map<String, Object?> toJson() => _$FinancialAccountBalanceOutputToJson(this);
}
