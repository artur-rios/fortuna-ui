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
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    name: json['name'] as String?,
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
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'name': ?instance.name,
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?CreateFinancialAccountCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
