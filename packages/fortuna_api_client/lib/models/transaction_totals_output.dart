// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_currency_total_output.dart';

part 'transaction_totals_output.g.dart';

@JsonSerializable()
class TransactionTotalsOutput {
  const TransactionTotalsOutput({
    this.byCurrency,
    this.displayCurrencyCode,
    this.displayEarning,
    this.displayExpense,
    this.displayNet,
  });

  factory TransactionTotalsOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionTotalsOutputFromJson(json);

  final List<TransactionCurrencyTotalOutput>? byCurrency;
  final String? displayCurrencyCode;
  final double? displayEarning;
  final double? displayExpense;
  final double? displayNet;

  Map<String, Object?> toJson() => _$TransactionTotalsOutputToJson(this);
}
