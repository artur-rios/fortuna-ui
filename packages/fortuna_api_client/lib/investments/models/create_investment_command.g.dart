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
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateInvestmentCommand._read_currencyCode(json['currencyCode']),
    institution: !json.containsKey('institution')
        ? null
        : CreateInvestmentCommand._read_institution(json['institution']),
    instrument: !json.containsKey('instrument')
        ? null
        : CreateInvestmentCommand._read_instrument(json['instrument']),
    investmentType: CreateInvestmentCommand._read_investmentType(
      json['investmentType'],
    ),
  );
}

Map<String, dynamic> _$CreateInvestmentCommandToJson(
  CreateInvestmentCommand instance,
) => <String, dynamic>{
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateInvestmentCommand._write_currencyCode($value),
  if (instance.institution case final $value?)
    'institution': CreateInvestmentCommand._write_institution($value),
  if (instance.instrument case final $value?)
    'instrument': CreateInvestmentCommand._write_instrument($value),
  'investmentType': ?CreateInvestmentCommand._write_investmentType(
    instance.investmentType,
  ),
};
