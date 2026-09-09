// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'credit_card_output.dart';

part 'credit_card_output_data_output.g.dart';

@JsonSerializable()
class CreditCardOutputDataOutput {
  const CreditCardOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory CreditCardOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$CreditCardOutputDataOutputFromJson(json);

  final CreditCardOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$CreditCardOutputDataOutputToJson(this);
}
