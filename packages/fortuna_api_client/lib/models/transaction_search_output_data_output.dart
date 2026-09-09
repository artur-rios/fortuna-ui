// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_search_output.dart';

part 'transaction_search_output_data_output.g.dart';

@JsonSerializable()
class TransactionSearchOutputDataOutput {
  const TransactionSearchOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TransactionSearchOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionSearchOutputDataOutputFromJson(json);

  final TransactionSearchOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$TransactionSearchOutputDataOutputToJson(this);
}
