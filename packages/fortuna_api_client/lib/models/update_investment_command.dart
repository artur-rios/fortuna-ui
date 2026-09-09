// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_type.dart';

part 'update_investment_command.g.dart';

@JsonSerializable()
class UpdateInvestmentCommand {
  const UpdateInvestmentCommand({
    this.currencyCode,
    this.institution,
    this.instrument,
    this.investmentType,
  });

  factory UpdateInvestmentCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateInvestmentCommandFromJson(json);

  final String? currencyCode;
  final String? institution;
  final String? instrument;
  final InvestmentType? investmentType;

  Map<String, Object?> toJson() => _$UpdateInvestmentCommandToJson(this);
}
