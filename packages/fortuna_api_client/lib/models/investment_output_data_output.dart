// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_output.dart';

part 'investment_output_data_output.g.dart';

@JsonSerializable()
class InvestmentOutputDataOutput {
  const InvestmentOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory InvestmentOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$InvestmentOutputDataOutputFromJson(json);

  final InvestmentOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$InvestmentOutputDataOutputToJson(this);
}
