// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'tag_output.dart';

part 'tag_list_output.g.dart';

@JsonSerializable()
class TagListOutput {
  const TagListOutput({
    this.pageNumber,
    this.pageSize,
    this.tags,
    this.totalItems,
    this.totalPages,
  });

  factory TagListOutput.fromJson(Map<String, Object?> json) =>
      _$TagListOutputFromJson(json);

  final int? pageNumber;
  final int? pageSize;
  final List<TagOutput>? tags;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() => _$TagListOutputToJson(this);
}
