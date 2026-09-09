// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'net_position_currency_output.g.dart';

@JsonSerializable()
class NetPositionCurrencyOutput {
  const NetPositionCurrencyOutput({
    this.appliedRate,
    this.creditCards,
    this.displayNet,
    this.financialAccounts,
    this.investments,
    this.rateDate,
    this.rateSource,
    this.sourceCurrencyCode,
    this.sourceNet,
    this.unconvertedReason,
  });

  factory NetPositionCurrencyOutput.fromJson(Map<String, Object?> json) =>
      _$NetPositionCurrencyOutputFromJson(json);

  final double? appliedRate;
  final double? creditCards;
  final double? displayNet;
  final double? financialAccounts;
  final double? investments;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? sourceCurrencyCode;
  final double? sourceNet;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$NetPositionCurrencyOutputToJson(this);
}
