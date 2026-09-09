// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'credit_card_lifecycle_command_output.g.dart';

@JsonSerializable()
class CreditCardLifecycleCommandOutput {
  const CreditCardLifecycleCommandOutput({
    this.currencyCode,
    this.id,
    this.outstandingAmount,
  });

  factory CreditCardLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CreditCardLifecycleCommandOutputFromJson(json);

  final String? currencyCode;
  final String? id;
  final double? outstandingAmount;

  Map<String, Object?> toJson() =>
      _$CreditCardLifecycleCommandOutputToJson(this);
}
