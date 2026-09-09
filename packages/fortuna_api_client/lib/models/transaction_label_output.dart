// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transaction_label_output.g.dart';

@JsonSerializable()
class TransactionLabelOutput {
  const TransactionLabelOutput({this.id, this.name});

  factory TransactionLabelOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionLabelOutputFromJson(json);

  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$TransactionLabelOutputToJson(this);
}
