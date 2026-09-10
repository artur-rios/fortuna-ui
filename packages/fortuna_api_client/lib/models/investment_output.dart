// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';
import 'investment_type.dart';

part 'investment_output.g.dart';

@JsonSerializable()
class InvestmentOutput {
  const InvestmentOutput({
    this.appliedRate,
    this.createdAt,
    this.currencyCode,
    this.displayCurrencyCode,
    this.displayPosition,
    this.id,
    this.institution,
    this.instrument,
    this.investmentType,
    this.isIndependentlyValued,
    this.latestValuationDate,
    this.latestValuationValue,
    this.position,
    this.rateDate,
    this.rateSource,
    this.unconvertedReason,
    this.updatedAt,
  });

  factory InvestmentOutput.fromJson(Map<String, Object?> json) =>
      _$InvestmentOutputFromJson(json);

  final String? appliedRate;
  final DateTime? createdAt;
  final String? currencyCode;
  final String? displayCurrencyCode;
  final String? displayPosition;
  final String? id;
  final String? institution;
  final String? instrument;
  final InvestmentType? investmentType;
  final bool? isIndependentlyValued;
  final DateTime? latestValuationDate;
  final String? latestValuationValue;
  final String? position;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? unconvertedReason;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$InvestmentOutputToJson(this);
}
