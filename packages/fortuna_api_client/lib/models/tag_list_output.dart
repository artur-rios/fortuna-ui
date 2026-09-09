// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'tag_output.dart';

part 'tag_list_output.g.dart';

@JsonSerializable()
class TagListOutput {
  const TagListOutput({this.tags});

  factory TagListOutput.fromJson(Map<String, Object?> json) =>
      _$TagListOutputFromJson(json);

  final List<TagOutput>? tags;

  Map<String, Object?> toJson() => _$TagListOutputToJson(this);
}
