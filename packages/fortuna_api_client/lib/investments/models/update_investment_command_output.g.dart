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
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    instrument: json['instrument'] as String?,
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
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'instrument': ?instance.instrument,
  'investmentType': ?UpdateInvestmentCommandOutput._write_investmentType(
    instance.investmentType,
  ),
  'updatedAt': ?UpdateInvestmentCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
