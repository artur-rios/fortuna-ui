// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'settle_credit_card_statement_command_output.dart';

part 'settle_credit_card_statement_command_output_data_output.g.dart';

@JsonSerializable()
class SettleCreditCardStatementCommandOutputDataOutput {
  const SettleCreditCardStatementCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory SettleCreditCardStatementCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$SettleCreditCardStatementCommandOutputDataOutputFromJson(json);

  final SettleCreditCardStatementCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$SettleCreditCardStatementCommandOutputDataOutputToJson(this);
}
