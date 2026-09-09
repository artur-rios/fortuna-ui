// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_investment_valuation_command_output.g.dart';

@JsonSerializable()
class RecordInvestmentValuationCommandOutput {
  const RecordInvestmentValuationCommandOutput({
    this.createdAt,
    this.currencyCode,
    this.id,
    this.investmentId,
    this.isIndependentlyValued,
    this.latestValuationDate,
    this.latestValuationValue,
    this.position,
    this.replacedExisting,
    this.updatedAt,
    this.value,
    this.valuedOn,
  });

  factory RecordInvestmentValuationCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecordInvestmentValuationCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? currencyCode;
  final String? id;
  final String? investmentId;
  final bool? isIndependentlyValued;
  final DateTime? latestValuationDate;
  final double? latestValuationValue;
  final double? position;
  final bool? replacedExisting;
  final DateTime? updatedAt;
  final double? value;
  final DateTime? valuedOn;

  Map<String, Object?> toJson() =>
      _$RecordInvestmentValuationCommandOutputToJson(this);
}
