// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommandOutput
_$CreateFinancialAccountCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'accountType',
      'createdAt',
      'currencyCode',
      'id',
      'institution',
      'name',
      'openingBalance',
      'updatedAt',
    ],
    disallowNullValues: const [
      'accountType',
      'createdAt',
      'id',
      'openingBalance',
      'updatedAt',
    ],
  );
  return CreateFinancialAccountCommandOutput(
    accountType: CreateFinancialAccountCommandOutput._read_accountType(
      json['accountType'],
    ),
    createdAt: CreateFinancialAccountCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateFinancialAccountCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : CreateFinancialAccountCommandOutput._read_institution(
            json['institution'],
          ),
    name: !json.containsKey('name')
        ? null
        : CreateFinancialAccountCommandOutput._read_name(json['name']),
    openingBalance: json['openingBalance'] as String?,
    updatedAt: CreateFinancialAccountCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$CreateFinancialAccountCommandOutputToJson(
  CreateFinancialAccountCommandOutput instance,
) => <String, dynamic>{
  'accountType': ?CreateFinancialAccountCommandOutput._write_accountType(
    instance.accountType,
  ),
  'createdAt': ?CreateFinancialAccountCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateFinancialAccountCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': CreateFinancialAccountCommandOutput._write_institution(
      $value,
    ),
  if (instance.name case final $value?)
    'name': CreateFinancialAccountCommandOutput._write_name($value),
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?CreateFinancialAccountCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
