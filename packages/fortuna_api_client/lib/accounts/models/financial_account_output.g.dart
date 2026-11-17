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
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
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
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'institution': ?instance.institution,
  'isDeleted': ?instance.isDeleted,
  'name': ?instance.name,
  'openingBalance': ?instance.openingBalance,
  'updatedAt': ?FinancialAccountOutput._write_updatedAt(instance.updatedAt),
};
