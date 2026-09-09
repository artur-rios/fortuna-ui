// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'operational_health_service_output.dart';

part 'operational_health_output.g.dart';

@JsonSerializable()
class OperationalHealthOutput {
  const OperationalHealthOutput({this.services, this.status});

  factory OperationalHealthOutput.fromJson(Map<String, Object?> json) =>
      _$OperationalHealthOutputFromJson(json);

  final List<OperationalHealthServiceOutput>? services;
  final String? status;

  Map<String, Object?> toJson() => _$OperationalHealthOutputToJson(this);
}
