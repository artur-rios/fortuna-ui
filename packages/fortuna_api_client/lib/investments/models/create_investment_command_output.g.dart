// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommandOutput _$CreateInvestmentCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'currencyCode',
      'id',
      'institution',
      'instrument',
      'investmentType',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'investmentType',
      'updatedAt',
    ],
  );
  return CreateInvestmentCommandOutput(
    createdAt: CreateInvestmentCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateInvestmentCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : CreateInvestmentCommandOutput._read_institution(json['institution']),
    instrument: !json.containsKey('instrument')
        ? null
        : CreateInvestmentCommandOutput._read_instrument(json['instrument']),
    investmentType: CreateInvestmentCommandOutput._read_investmentType(
      json['investmentType'],
    ),
    updatedAt: CreateInvestmentCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CreateInvestmentCommandOutputToJson(
  CreateInvestmentCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?CreateInvestmentCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateInvestmentCommandOutput._write_currencyCode($value),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': CreateInvestmentCommandOutput._write_institution($value),
  if (instance.instrument case final $value?)
    'instrument': CreateInvestmentCommandOutput._write_instrument($value),
  'investmentType': ?CreateInvestmentCommandOutput._write_investmentType(
    instance.investmentType,
  ),
  'updatedAt': ?CreateInvestmentCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
