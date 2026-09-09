// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'currency_output.g.dart';

@JsonSerializable()
class CurrencyOutput {
  const CurrencyOutput({this.code, this.minorUnitDigits, this.name});

  factory CurrencyOutput.fromJson(Map<String, Object?> json) =>
      _$CurrencyOutputFromJson(json);

  final String? code;
  final int? minorUnitDigits;
  final String? name;

  Map<String, Object?> toJson() => _$CurrencyOutputToJson(this);
}
