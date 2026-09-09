// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_type.dart';

part 'create_investment_command_output.g.dart';

@JsonSerializable()
class CreateInvestmentCommandOutput {
  const CreateInvestmentCommandOutput({
    this.createdAt,
    this.currencyCode,
    this.id,
    this.institution,
    this.instrument,
    this.investmentType,
    this.updatedAt,
  });

  factory CreateInvestmentCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CreateInvestmentCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? institution;
  final String? instrument;
  final InvestmentType? investmentType;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CreateInvestmentCommandOutputToJson(this);
}
