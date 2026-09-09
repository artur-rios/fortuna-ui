// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'investment_valuation_output.g.dart';

@JsonSerializable()
class InvestmentValuationOutput {
  const InvestmentValuationOutput({
    this.createdAt,
    this.currencyCode,
    this.id,
    this.investmentId,
    this.updatedAt,
    this.value,
    this.valuedOn,
  });

  factory InvestmentValuationOutput.fromJson(Map<String, Object?> json) =>
      _$InvestmentValuationOutputFromJson(json);

  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? investmentId;
  final DateTime? updatedAt;
  final double? value;
  final DateTime? valuedOn;

  Map<String, Object?> toJson() => _$InvestmentValuationOutputToJson(this);
}
