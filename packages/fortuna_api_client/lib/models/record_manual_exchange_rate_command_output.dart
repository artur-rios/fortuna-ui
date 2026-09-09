// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';

part 'record_manual_exchange_rate_command_output.g.dart';

@JsonSerializable()
class RecordManualExchangeRateCommandOutput {
  const RecordManualExchangeRateCommandOutput({
    this.baseCurrencyCode,
    this.quoteCurrencyCode,
    this.rate,
    this.rateDate,
    this.replacedExisting,
    this.source,
    this.takesPrecedence,
  });

  factory RecordManualExchangeRateCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecordManualExchangeRateCommandOutputFromJson(json);

  final String? baseCurrencyCode;
  final String? quoteCurrencyCode;
  final double? rate;
  final DateTime? rateDate;
  final bool? replacedExisting;
  final ExchangeRateSource? source;
  final bool? takesPrecedence;

  Map<String, Object?> toJson() =>
      _$RecordManualExchangeRateCommandOutputToJson(this);
}
