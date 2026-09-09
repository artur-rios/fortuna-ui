// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_transaction_tag_output.g.dart';

@JsonSerializable()
class UpdateTransactionTagOutput {
  const UpdateTransactionTagOutput({this.id, this.name});

  factory UpdateTransactionTagOutput.fromJson(Map<String, Object?> json) =>
      _$UpdateTransactionTagOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$UpdateTransactionTagOutputToJson(this);
}
