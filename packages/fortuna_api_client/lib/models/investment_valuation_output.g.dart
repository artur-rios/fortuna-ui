// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_valuation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentValuationOutput _$InvestmentValuationOutputFromJson(
  Map<String, dynamic> json,
) => InvestmentValuationOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  investmentId: json['investmentId'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  value: json['value'] as String?,
  valuedOn: json['valuedOn'] == null
      ? null
      : DateTime.parse(json['valuedOn'] as String),
);

Map<String, dynamic> _$InvestmentValuationOutputToJson(
  InvestmentValuationOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'investmentId': instance.investmentId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'value': instance.value,
  'valuedOn': instance.valuedOn?.toIso8601String(),
};
