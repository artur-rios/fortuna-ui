// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transaction_tag_command_output.g.dart';

@JsonSerializable()
class TransactionTagCommandOutput {
  const TransactionTagCommandOutput({
    this.id,
    this.isAttached,
    this.tagCount,
    this.tagId,
  });

  factory TransactionTagCommandOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionTagCommandOutputFromJson(json);

  final String? id;
  final bool? isAttached;
  final int? tagCount;
  final String? tagId;

  Map<String, Object?> toJson() => _$TransactionTagCommandOutputToJson(this);
}
