// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_investment_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInvestmentCommandOutput _$UpdateInvestmentCommandOutputFromJson(
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
  return UpdateInvestmentCommandOutput(
    createdAt: UpdateInvestmentCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateInvestmentCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : UpdateInvestmentCommandOutput._read_institution(json['institution']),
    instrument: !json.containsKey('instrument')
        ? null
        : UpdateInvestmentCommandOutput._read_instrument(json['instrument']),
    investmentType: UpdateInvestmentCommandOutput._read_investmentType(
      json['investmentType'],
    ),
    updatedAt: UpdateInvestmentCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$UpdateInvestmentCommandOutputToJson(
  UpdateInvestmentCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?UpdateInvestmentCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateInvestmentCommandOutput._write_currencyCode($value),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': UpdateInvestmentCommandOutput._write_institution($value),
  if (instance.instrument case final $value?)
    'instrument': UpdateInvestmentCommandOutput._write_instrument($value),
  'investmentType': ?UpdateInvestmentCommandOutput._write_investmentType(
    instance.investmentType,
  ),
  'updatedAt': ?UpdateInvestmentCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
