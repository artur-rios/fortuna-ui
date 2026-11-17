// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutput _$FinancialAccountOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'accountType',
      'createdAt',
      'currencyCode',
      'id',
      'institution',
      'isDeleted',
      'name',
      'openingBalance',
      'updatedAt',
    ],
    disallowNullValues: const [
      'accountType',
      'createdAt',
      'id',
      'isDeleted',
      'openingBalance',
      'updatedAt',
    ],
  );
  return FinancialAccountOutput(
    accountType: FinancialAccountOutput._read_accountType(json['accountType']),
    createdAt: FinancialAccountOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : FinancialAccountOutput._read_currencyCode(json['currencyCode']),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : FinancialAccountOutput._read_institution(json['institution']),
    isDeleted: json['isDeleted'] as bool?,
    name: !json.containsKey('name')
        ? null
        : FinancialAccountOutput._read_name(json['name']),
    openingBalance: json['openingBalance'] as String?,
    updatedAt: FinancialAccountOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$FinancialAccountOutputToJson(
  FinancialAccountOutput instance,
) => <String, dynamic>{
  'accountType': ?FinancialAccountOutput._write_accountType(
    instance.accountType,
  ),
  'createdAt': ?FinancialAccountOutput._write_createdAt(instance.createdAt),
  if (instance.currencyCode case final $value?)
    'currencyCode': FinancialAccountOutput._write_currencyCode($value),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': FinancialAccountOutput._write_institution($value),
  'isDeleted': ?instance.isDeleted,
  if (instance.name case final $value?)
    'name': FinancialAccountOutput._write_name($value),
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?FinancialAccountOutput._write_updatedAt(instance.updatedAt),
};
