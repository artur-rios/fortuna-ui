// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'processing_consent_query_output.dart';

part 'processing_consent_query_output_data_output.g.dart';

@JsonSerializable()
class ProcessingConsentQueryOutputDataOutput {
  const ProcessingConsentQueryOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ProcessingConsentQueryOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ProcessingConsentQueryOutputDataOutputFromJson(json);

  final ProcessingConsentQueryOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ProcessingConsentQueryOutputDataOutputToJson(this);
}
