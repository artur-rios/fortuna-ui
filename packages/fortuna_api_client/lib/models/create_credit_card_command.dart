// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_credit_card_command.g.dart';

@JsonSerializable()
class CreateCreditCardCommand {
  const CreateCreditCardCommand({
    this.closingDay,
    this.creditLimit,
    this.currencyCode,
    this.dueDay,
    this.issuer,
    this.lastFourDigits,
    this.name,
  });

  factory CreateCreditCardCommand.fromJson(Map<String, Object?> json) =>
      _$CreateCreditCardCommandFromJson(json);

  final int? closingDay;
  final String? creditLimit;
  final String? currencyCode;
  final int? dueDay;
  final String? issuer;
  final String? lastFourDigits;
  final String? name;

  Map<String, Object?> toJson() => _$CreateCreditCardCommandToJson(this);
}
