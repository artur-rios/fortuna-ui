// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'record_manual_exchange_rate_command_output.dart';

part 'record_manual_exchange_rate_command_output_data_output.g.dart';

@JsonSerializable()
class RecordManualExchangeRateCommandOutputDataOutput {
  const RecordManualExchangeRateCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory RecordManualExchangeRateCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecordManualExchangeRateCommandOutputDataOutputFromJson(json);

  final RecordManualExchangeRateCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$RecordManualExchangeRateCommandOutputDataOutputToJson(this);
}
