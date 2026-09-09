// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'credit_card_lifecycle_command_output.dart';

part 'credit_card_lifecycle_command_output_data_output.g.dart';

@JsonSerializable()
class CreditCardLifecycleCommandOutputDataOutput {
  const CreditCardLifecycleCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory CreditCardLifecycleCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CreditCardLifecycleCommandOutputDataOutputFromJson(json);

  final CreditCardLifecycleCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$CreditCardLifecycleCommandOutputDataOutputToJson(this);
}
