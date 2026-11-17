// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommand _$CreateInvestmentCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'currencyCode',
      'institution',
      'instrument',
      'investmentType',
    ],
    disallowNullValues: const ['investmentType'],
  );
  return CreateInvestmentCommand(
    currencyCode: json['currencyCode'] as String?,
    institution: json['institution'] as String?,
    instrument: json['instrument'] as String?,
    investmentType: CreateInvestmentCommand._read_investmentType(
      json['investmentType'],
    ),
  );
}

Map<String, dynamic> _$CreateInvestmentCommandToJson(
  CreateInvestmentCommand instance,
) => <String, dynamic>{
  'currencyCode': ?instance.currencyCode,
  'institution': ?instance.institution,
  'instrument': ?instance.instrument,
  'investmentType': ?CreateInvestmentCommand._write_investmentType(
    instance.investmentType,
  ),
};
