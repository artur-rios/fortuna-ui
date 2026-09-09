// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'close_credit_card_statement_command_output.dart';

part 'close_credit_card_statement_command_output_data_output.g.dart';

@JsonSerializable()
class CloseCreditCardStatementCommandOutputDataOutput {
  const CloseCreditCardStatementCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory CloseCreditCardStatementCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CloseCreditCardStatementCommandOutputDataOutputFromJson(json);

  final CloseCreditCardStatementCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$CloseCreditCardStatementCommandOutputDataOutputToJson(this);
}
