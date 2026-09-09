// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'tag_command_output.g.dart';

@JsonSerializable()
class TagCommandOutput {
  const TagCommandOutput({
    this.createdAt,
    this.detachedTransactionCount,
    this.id,
    this.isDeleted,
    this.name,
    this.updatedAt,
  });

  factory TagCommandOutput.fromJson(Map<String, Object?> json) =>
      _$TagCommandOutputFromJson(json);

  final DateTime? createdAt;
  final int? detachedTransactionCount;
  final String? id;
  final bool? isDeleted;
  final String? name;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$TagCommandOutputToJson(this);
}
