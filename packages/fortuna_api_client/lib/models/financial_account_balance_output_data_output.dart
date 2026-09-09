// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_balance_output.dart';

part 'financial_account_balance_output_data_output.g.dart';

@JsonSerializable()
class FinancialAccountBalanceOutputDataOutput {
  const FinancialAccountBalanceOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory FinancialAccountBalanceOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$FinancialAccountBalanceOutputDataOutputFromJson(json);

  final FinancialAccountBalanceOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$FinancialAccountBalanceOutputDataOutputToJson(this);
}
