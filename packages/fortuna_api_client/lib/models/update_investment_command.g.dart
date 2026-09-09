// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_investment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInvestmentCommand _$UpdateInvestmentCommandFromJson(
  Map<String, dynamic> json,
) => UpdateInvestmentCommand(
  currencyCode: json['currencyCode'] as String?,
  institution: json['institution'] as String?,
  instrument: json['instrument'] as String?,
  investmentType: json['investmentType'] == null
      ? null
      : InvestmentType.fromJson((json['investmentType'] as num).toInt()),
);

Map<String, dynamic> _$UpdateInvestmentCommandToJson(
  UpdateInvestmentCommand instance,
) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'institution': instance.institution,
  'instrument': instance.instrument,
  'investmentType': instance.investmentType,
};
