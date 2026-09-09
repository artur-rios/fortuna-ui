// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_type.dart';

part 'create_financial_account_command_output.g.dart';

@JsonSerializable()
class CreateFinancialAccountCommandOutput {
  const CreateFinancialAccountCommandOutput({
    this.accountType,
    this.createdAt,
    this.currencyCode,
    this.id,
    this.institution,
    this.name,
    this.openingBalance,
    this.updatedAt,
  });

  factory CreateFinancialAccountCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CreateFinancialAccountCommandOutputFromJson(json);

  final FinancialAccountType? accountType;
  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? institution;
  final String? name;
  final double? openingBalance;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() =>
      _$CreateFinancialAccountCommandOutputToJson(this);
}
