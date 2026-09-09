// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_category_command_output.g.dart';

@JsonSerializable()
class UpdateCategoryCommandOutput {
  const UpdateCategoryCommandOutput({
    this.createdAt,
    this.id,
    this.name,
    this.parentId,
    this.updatedAt,
  });

  factory UpdateCategoryCommandOutput.fromJson(Map<String, Object?> json) =>
      _$UpdateCategoryCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? id;
  final String? name;
  final String? parentId;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$UpdateCategoryCommandOutputToJson(this);
}
