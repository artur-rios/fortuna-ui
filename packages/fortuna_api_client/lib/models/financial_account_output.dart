// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_type.dart';

part 'financial_account_output.g.dart';

@JsonSerializable()
class FinancialAccountOutput {
  const FinancialAccountOutput({
    this.accountType,
    this.createdAt,
    this.currencyCode,
    this.id,
    this.institution,
    this.isDeleted,
    this.name,
    this.openingBalance,
    this.updatedAt,
  });

  factory FinancialAccountOutput.fromJson(Map<String, Object?> json) =>
      _$FinancialAccountOutputFromJson(json);

  final FinancialAccountType? accountType;
  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? institution;
  final bool? isDeleted;
  final String? name;
  final String? openingBalance;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$FinancialAccountOutputToJson(this);
}
