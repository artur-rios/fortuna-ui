// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommandOutput _$CreateInvestmentCommandOutputFromJson(
  Map<String, dynamic> json,
) => CreateInvestmentCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  institution: json['institution'] as String?,
  instrument: json['instrument'] as String?,
  investmentType: json['investmentType'] == null
      ? null
      : InvestmentType.fromJson((json['investmentType'] as num).toInt()),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CreateInvestmentCommandOutputToJson(
  CreateInvestmentCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'institution': instance.institution,
  'instrument': instance.instrument,
  'investmentType': _$InvestmentTypeEnumMap[instance.investmentType],
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$InvestmentTypeEnumMap = {
  InvestmentType.value1: 1,
  InvestmentType.value2: 2,
  InvestmentType.value3: 3,
  InvestmentType.value4: 4,
  InvestmentType.$unknown: r'$unknown',
};
