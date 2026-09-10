// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_type.dart';

part 'create_financial_account_command.g.dart';

@JsonSerializable()
class CreateFinancialAccountCommand {
  const CreateFinancialAccountCommand({
    this.accountType,
    this.currencyCode,
    this.institution,
    this.name,
    this.openingBalance,
  });

  factory CreateFinancialAccountCommand.fromJson(Map<String, Object?> json) =>
      _$CreateFinancialAccountCommandFromJson(json);

  final FinancialAccountType? accountType;
  final String? currencyCode;
  final String? institution;
  final String? name;
  final String? openingBalance;

  Map<String, Object?> toJson() => _$CreateFinancialAccountCommandToJson(this);
}
