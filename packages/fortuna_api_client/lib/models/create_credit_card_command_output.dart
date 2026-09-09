// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_credit_card_command_output.g.dart';

@JsonSerializable()
class CreateCreditCardCommandOutput {
  const CreateCreditCardCommandOutput({
    this.closingDay,
    this.createdAt,
    this.creditLimit,
    this.currencyCode,
    this.dueDay,
    this.id,
    this.issuer,
    this.lastFourDigits,
    this.name,
    this.updatedAt,
  });

  factory CreateCreditCardCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CreateCreditCardCommandOutputFromJson(json);

  final int? closingDay;
  final DateTime? createdAt;
  final double? creditLimit;
  final String? currencyCode;
  final int? dueDay;
  final String? id;
  final String? issuer;
  final String? lastFourDigits;
  final String? name;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CreateCreditCardCommandOutputToJson(this);
}
