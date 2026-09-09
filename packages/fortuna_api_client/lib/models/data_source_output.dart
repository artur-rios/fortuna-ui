// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_source_kind.dart';

part 'data_source_output.g.dart';

@JsonSerializable()
class DataSourceOutput {
  const DataSourceOutput({
    this.displayName,
    this.isAvailable,
    this.isNetworkBacked,
    this.kind,
    this.name,
    this.requiredInputs,
    this.supportedFormats,
    this.supportedLayouts,
    this.unavailableReason,
  });

  factory DataSourceOutput.fromJson(Map<String, Object?> json) =>
      _$DataSourceOutputFromJson(json);

  final String? displayName;
  final bool? isAvailable;
  final bool? isNetworkBacked;
  final DataSourceKind? kind;
  final String? name;
  final List<String>? requiredInputs;
  final List<String>? supportedFormats;
  final List<String>? supportedLayouts;
  final String? unavailableReason;

  Map<String, Object?> toJson() => _$DataSourceOutputToJson(this);
}
