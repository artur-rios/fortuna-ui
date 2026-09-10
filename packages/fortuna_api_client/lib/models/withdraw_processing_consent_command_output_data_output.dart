// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'withdraw_processing_consent_command_output.dart';

part 'withdraw_processing_consent_command_output_data_output.g.dart';

@JsonSerializable()
class WithdrawProcessingConsentCommandOutputDataOutput {
  const WithdrawProcessingConsentCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory WithdrawProcessingConsentCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$WithdrawProcessingConsentCommandOutputDataOutputFromJson(json);

  final WithdrawProcessingConsentCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$WithdrawProcessingConsentCommandOutputDataOutputToJson(this);
}
