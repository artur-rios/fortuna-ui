// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'table_total_conversion_output.g.dart';

@JsonSerializable()
class TableTotalConversionOutput {
  const TableTotalConversionOutput({
    this.appliedRate,
    this.convertedValue,
    this.figureDate,
    this.rateDate,
    this.rateSource,
    this.sourceCurrencyCode,
    this.sourceValue,
    this.unconvertedReason,
  });

  factory TableTotalConversionOutput.fromJson(Map<String, Object?> json) =>
      _$TableTotalConversionOutputFromJson(json);

  final double? appliedRate;
  final double? convertedValue;
  final DateTime? figureDate;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? sourceCurrencyCode;
  final double? sourceValue;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$TableTotalConversionOutputToJson(this);
}
