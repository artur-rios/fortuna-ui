// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_type.dart';

part 'update_investment_command_output.g.dart';

@JsonSerializable()
class UpdateInvestmentCommandOutput {
  const UpdateInvestmentCommandOutput({
    this.createdAt,
    this.currencyCode,
    this.id,
    this.institution,
    this.instrument,
    this.investmentType,
    this.updatedAt,
  });

  factory UpdateInvestmentCommandOutput.fromJson(Map<String, Object?> json) =>
      _$UpdateInvestmentCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? institution;
  final String? instrument;
  final InvestmentType? investmentType;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$UpdateInvestmentCommandOutputToJson(this);
}
