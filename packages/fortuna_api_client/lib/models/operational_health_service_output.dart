// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'operational_health_service_output.g.dart';

@JsonSerializable()
class OperationalHealthServiceOutput {
  const OperationalHealthServiceOutput({
    this.name,
    this.oldestPendingSeconds,
    this.queueDepth,
    this.status,
  });

  factory OperationalHealthServiceOutput.fromJson(Map<String, Object?> json) =>
      _$OperationalHealthServiceOutputFromJson(json);

  final String? name;
  final int? oldestPendingSeconds;
  final int? queueDepth;
  final String? status;

  Map<String, Object?> toJson() => _$OperationalHealthServiceOutputToJson(this);
}
