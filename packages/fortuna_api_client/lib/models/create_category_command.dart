// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_category_command.g.dart';

@JsonSerializable()
class CreateCategoryCommand {
  const CreateCategoryCommand({this.name, this.parentId});

  factory CreateCategoryCommand.fromJson(Map<String, Object?> json) =>
      _$CreateCategoryCommandFromJson(json);

  final String? name;
  final String? parentId;

  Map<String, Object?> toJson() => _$CreateCategoryCommandToJson(this);
}
