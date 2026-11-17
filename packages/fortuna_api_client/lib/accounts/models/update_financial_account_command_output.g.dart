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
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateFinancialAccountCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : UpdateFinancialAccountCommandOutput._read_institution(
            json['institution'],
          ),
    name: !json.containsKey('name')
        ? null
        : UpdateFinancialAccountCommandOutput._read_name(json['name']),
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
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateFinancialAccountCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': UpdateFinancialAccountCommandOutput._write_institution(
      $value,
    ),
  if (instance.name case final $value?)
    'name': UpdateFinancialAccountCommandOutput._write_name($value),
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?UpdateFinancialAccountCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
