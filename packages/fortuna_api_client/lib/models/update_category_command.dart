// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_category_command.g.dart';

@JsonSerializable()
class UpdateCategoryCommand {
  const UpdateCategoryCommand({this.name, this.parentId});

  factory UpdateCategoryCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateCategoryCommandFromJson(json);

  final String? name;
  final String? parentId;

  Map<String, Object?> toJson() => _$UpdateCategoryCommandToJson(this);
}
