// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_type.dart';

part 'create_investment_command.g.dart';

@JsonSerializable()
class CreateInvestmentCommand {
  const CreateInvestmentCommand({
    this.currencyCode,
    this.institution,
    this.instrument,
    this.investmentType,
  });

  factory CreateInvestmentCommand.fromJson(Map<String, Object?> json) =>
      _$CreateInvestmentCommandFromJson(json);

  final String? currencyCode;
  final String? institution;
  final String? instrument;
  final InvestmentType? investmentType;

  Map<String, Object?> toJson() => _$CreateInvestmentCommandToJson(this);
}
