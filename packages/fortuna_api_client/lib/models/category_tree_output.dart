// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_output.dart';

part 'category_tree_output.g.dart';

@JsonSerializable()
class CategoryTreeOutput {
  const CategoryTreeOutput({this.canSeedDefaults, this.categories});

  factory CategoryTreeOutput.fromJson(Map<String, Object?> json) =>
      _$CategoryTreeOutputFromJson(json);

  final bool? canSeedDefaults;
  final List<CategoryOutput>? categories;

  Map<String, Object?> toJson() => _$CategoryTreeOutputToJson(this);
}
