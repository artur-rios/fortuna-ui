// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommand _$CreateInvestmentCommandFromJson(
  Map<String, dynamic> json,
) => CreateInvestmentCommand(
  currencyCode: json['currencyCode'] as String?,
  institution: json['institution'] as String?,
  instrument: json['instrument'] as String?,
  investmentType: json['investmentType'] == null
      ? null
      : InvestmentType.fromJson((json['investmentType'] as num).toInt()),
);

Map<String, dynamic> _$CreateInvestmentCommandToJson(
  CreateInvestmentCommand instance,
) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'institution': instance.institution,
  'instrument': instance.instrument,
  'investmentType': _$InvestmentTypeEnumMap[instance.investmentType],
};

const _$InvestmentTypeEnumMap = {
  InvestmentType.value1: 1,
  InvestmentType.value2: 2,
  InvestmentType.value3: 3,
  InvestmentType.value4: 4,
  InvestmentType.$unknown: r'$unknown',
};
