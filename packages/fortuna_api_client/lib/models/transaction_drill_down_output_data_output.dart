// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_drill_down_output.dart';

part 'transaction_drill_down_output_data_output.g.dart';

@JsonSerializable()
class TransactionDrillDownOutputDataOutput {
  const TransactionDrillDownOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TransactionDrillDownOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionDrillDownOutputDataOutputFromJson(json);

  final TransactionDrillDownOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$TransactionDrillDownOutputDataOutputToJson(this);
}
