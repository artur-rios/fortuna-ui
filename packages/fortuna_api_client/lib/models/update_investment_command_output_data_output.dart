// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_investment_command_output.dart';

part 'update_investment_command_output_data_output.g.dart';

@JsonSerializable()
class UpdateInvestmentCommandOutputDataOutput {
  const UpdateInvestmentCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory UpdateInvestmentCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$UpdateInvestmentCommandOutputDataOutputFromJson(json);

  final UpdateInvestmentCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$UpdateInvestmentCommandOutputDataOutputToJson(this);
}
