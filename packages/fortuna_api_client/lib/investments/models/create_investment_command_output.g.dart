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
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    instrument: json['instrument'] as String?,
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
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'instrument': ?instance.instrument,
  'investmentType': ?CreateInvestmentCommandOutput._write_investmentType(
    instance.investmentType,
  ),
  'updatedAt': ?CreateInvestmentCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
