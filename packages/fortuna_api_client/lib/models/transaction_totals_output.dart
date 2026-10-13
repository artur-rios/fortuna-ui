// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'missing_exchange_rate_output.dart';
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
    this.isFullyConverted,
    this.missingRates,
  });

  factory TransactionTotalsOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionTotalsOutputFromJson(json);

  final List<TransactionCurrencyTotalOutput>? byCurrency;
  final String? displayCurrencyCode;
  final String? displayEarning;
  final String? displayExpense;
  final String? displayNet;
  final bool? isFullyConverted;
  final List<MissingExchangeRateOutput>? missingRates;

  Map<String, Object?> toJson() => _$TransactionTotalsOutputToJson(this);
}
