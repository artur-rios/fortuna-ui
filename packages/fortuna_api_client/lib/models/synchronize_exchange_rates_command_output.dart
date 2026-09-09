// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'synchronize_exchange_rates_command_output.g.dart';

@JsonSerializable()
class SynchronizeExchangeRatesCommandOutput {
  const SynchronizeExchangeRatesCommandOutput({this.jobId, this.requestedDate});

  factory SynchronizeExchangeRatesCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$SynchronizeExchangeRatesCommandOutputFromJson(json);

  final String? jobId;
  final DateTime? requestedDate;

  Map<String, Object?> toJson() =>
      _$SynchronizeExchangeRatesCommandOutputToJson(this);
}
