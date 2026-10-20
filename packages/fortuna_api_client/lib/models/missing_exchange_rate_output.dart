// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'missing_exchange_rate_output.g.dart';

@JsonSerializable()
class MissingExchangeRateOutput {
  const MissingExchangeRateOutput({
    this.baseCurrencyCode,
    this.quoteCurrencyCode,
  });

  factory MissingExchangeRateOutput.fromJson(Map<String, Object?> json) =>
      _$MissingExchangeRateOutputFromJson(json);

  final String? baseCurrencyCode;
  final String? quoteCurrencyCode;

  Map<String, Object?> toJson() => _$MissingExchangeRateOutputToJson(this);
}
