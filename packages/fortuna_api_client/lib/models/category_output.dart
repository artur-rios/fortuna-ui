// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_output.dart';

part 'category_output.g.dart';

@JsonSerializable()
class CategoryOutput {
  const CategoryOutput({
    this.children,
    this.createdAt,
    this.id,
    this.isDeleted,
    this.name,
    this.parentId,
    this.updatedAt,
    this.usageCount,
  });

  factory CategoryOutput.fromJson(Map<String, Object?> json) =>
      _$CategoryOutputFromJson(json);

  final List<CategoryOutput>? children;
  final DateTime? createdAt;
  final String? id;
  final bool? isDeleted;
  final String? name;
  final String? parentId;
  final DateTime? updatedAt;
  final int? usageCount;

  Map<String, Object?> toJson() => _$CategoryOutputToJson(this);
}
