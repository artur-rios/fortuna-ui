// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_tree_output.dart';

part 'category_tree_output_data_output.g.dart';

@JsonSerializable()
class CategoryTreeOutputDataOutput {
  const CategoryTreeOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory CategoryTreeOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$CategoryTreeOutputDataOutputFromJson(json);

  final CategoryTreeOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$CategoryTreeOutputDataOutputToJson(this);
}
