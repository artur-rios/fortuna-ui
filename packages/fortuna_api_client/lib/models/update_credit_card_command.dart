// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_credit_card_command.g.dart';

@JsonSerializable()
class UpdateCreditCardCommand {
  const UpdateCreditCardCommand({
    this.closingDay,
    this.creditLimit,
    this.currencyCode,
    this.dueDay,
    this.issuer,
    this.name,
  });

  factory UpdateCreditCardCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateCreditCardCommandFromJson(json);

  final int? closingDay;
  final double? creditLimit;
  final String? currencyCode;
  final int? dueDay;
  final String? issuer;
  final String? name;

  Map<String, Object?> toJson() => _$UpdateCreditCardCommandToJson(this);
}
