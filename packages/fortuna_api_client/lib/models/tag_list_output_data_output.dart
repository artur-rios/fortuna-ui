// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'tag_list_output.dart';

part 'tag_list_output_data_output.g.dart';

@JsonSerializable()
class TagListOutputDataOutput {
  const TagListOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TagListOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$TagListOutputDataOutputFromJson(json);

  final TagListOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$TagListOutputDataOutputToJson(this);
}
