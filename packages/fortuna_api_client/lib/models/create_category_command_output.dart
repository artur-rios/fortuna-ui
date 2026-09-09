// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_category_command_output.g.dart';

@JsonSerializable()
class CreateCategoryCommandOutput {
  const CreateCategoryCommandOutput({
    this.createdAt,
    this.id,
    this.name,
    this.parentId,
    this.updatedAt,
  });

  factory CreateCategoryCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CreateCategoryCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? id;
  final String? name;
  final String? parentId;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CreateCategoryCommandOutputToJson(this);
}
