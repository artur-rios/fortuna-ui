// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transfer_output.dart';

part 'transfer_output_data_output.g.dart';

@JsonSerializable()
class TransferOutputDataOutput {
  const TransferOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory TransferOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$TransferOutputDataOutputFromJson(json);

  final TransferOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$TransferOutputDataOutputToJson(this);
}
