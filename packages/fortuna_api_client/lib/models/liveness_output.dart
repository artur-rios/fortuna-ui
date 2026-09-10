// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'liveness_output.g.dart';

@JsonSerializable()
class LivenessOutput {
  const LivenessOutput({required this.contractVersion, required this.service});

  factory LivenessOutput.fromJson(Map<String, Object?> json) =>
      _$LivenessOutputFromJson(json);

  final String? contractVersion;
  final String? service;

  Map<String, Object?> toJson() => _$LivenessOutputToJson(this);
}
