// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transaction_tag_output.g.dart';

@JsonSerializable()
class TransactionTagOutput {
  const TransactionTagOutput({this.id, this.name});

  factory TransactionTagOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionTagOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$TransactionTagOutputToJson(this);
}
