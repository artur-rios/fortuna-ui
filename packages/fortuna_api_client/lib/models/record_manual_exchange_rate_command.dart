// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_manual_exchange_rate_command.g.dart';

@JsonSerializable()
class RecordManualExchangeRateCommand {
  const RecordManualExchangeRateCommand({
    this.baseCurrencyCode,
    this.quoteCurrencyCode,
    this.rate,
    this.rateDate,
  });

  factory RecordManualExchangeRateCommand.fromJson(Map<String, Object?> json) =>
      _$RecordManualExchangeRateCommandFromJson(json);

  final String? baseCurrencyCode;
  final String? quoteCurrencyCode;
  final String? rate;
  final DateTime? rateDate;

  Map<String, Object?> toJson() =>
      _$RecordManualExchangeRateCommandToJson(this);
}
