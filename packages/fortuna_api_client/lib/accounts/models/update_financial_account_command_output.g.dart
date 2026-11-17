// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommandOutput
_$UpdateFinancialAccountCommandOutputFromJson(Map<String, dynamic> json) {
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
  return UpdateFinancialAccountCommandOutput(
    accountType: UpdateFinancialAccountCommandOutput._read_accountType(
      json['accountType'],
    ),
    createdAt: UpdateFinancialAccountCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    name: json['name'] as String?,
    openingBalance: json['openingBalance'] as String?,
    updatedAt: UpdateFinancialAccountCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$UpdateFinancialAccountCommandOutputToJson(
  UpdateFinancialAccountCommandOutput instance,
) => <String, dynamic>{
  'accountType': ?UpdateFinancialAccountCommandOutput._write_accountType(
    instance.accountType,
  ),
  'createdAt': ?UpdateFinancialAccountCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'name': ?instance.name,
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?UpdateFinancialAccountCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
