// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'credit_card_output.g.dart';

@JsonSerializable()
class CreditCardOutput {
  const CreditCardOutput({
    this.availableAmount,
    this.closingDay,
    this.createdAt,
    this.creditLimit,
    this.currencyCode,
    this.dueDay,
    this.id,
    this.issuer,
    this.lastFourDigits,
    this.name,
    this.overageAmount,
    this.updatedAt,
    this.usedAmount,
  });

  factory CreditCardOutput.fromJson(Map<String, Object?> json) =>
      _$CreditCardOutputFromJson(json);

  final String? availableAmount;
  final int? closingDay;
  final DateTime? createdAt;
  final String? creditLimit;
  final String? currencyCode;
  final int? dueDay;
  final String? id;
  final String? issuer;
  final String? lastFourDigits;
  final String? name;
  final String? overageAmount;
  final DateTime? updatedAt;
  final String? usedAmount;

  Map<String, Object?> toJson() => _$CreditCardOutputToJson(this);
}
