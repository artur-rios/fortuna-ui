// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'processing_consent_state_output.dart';

part 'processing_consent_query_output.g.dart';

@JsonSerializable()
class ProcessingConsentQueryOutput {
  const ProcessingConsentQueryOutput({this.consents});

  factory ProcessingConsentQueryOutput.fromJson(Map<String, Object?> json) =>
      _$ProcessingConsentQueryOutputFromJson(json);

  final List<ProcessingConsentStateOutput>? consents;

  Map<String, Object?> toJson() => _$ProcessingConsentQueryOutputToJson(this);
}
