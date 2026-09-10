// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'transaction_currency_total_output.g.dart';

@JsonSerializable()
class TransactionCurrencyTotalOutput {
  const TransactionCurrencyTotalOutput({
    this.appliedRate,
    this.currencyCode,
    this.displayCurrencyCode,
    this.displayEarning,
    this.displayExpense,
    this.displayNet,
    this.earning,
    this.expense,
    this.net,
    this.rateDate,
    this.rateSource,
    this.unconvertedReason,
  });

  factory TransactionCurrencyTotalOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionCurrencyTotalOutputFromJson(json);

  final String? appliedRate;
  final String? currencyCode;
  final String? displayCurrencyCode;
  final String? displayEarning;
  final String? displayExpense;
  final String? displayNet;
  final String? earning;
  final String? expense;
  final String? net;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$TransactionCurrencyTotalOutputToJson(this);
}
