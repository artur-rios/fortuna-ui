// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'category_lifecycle_command_output.g.dart';

@JsonSerializable()
class CategoryLifecycleCommandOutput {
  const CategoryLifecycleCommandOutput({this.id, this.liveTransactionCount});

  factory CategoryLifecycleCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CategoryLifecycleCommandOutputFromJson(json);

  final String? id;
  final int? liveTransactionCount;

  Map<String, Object?> toJson() => _$CategoryLifecycleCommandOutputToJson(this);
}
