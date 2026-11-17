// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommand _$CreateFinancialAccountCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'accountType',
      'currencyCode',
      'institution',
      'name',
      'openingBalance',
    ],
    disallowNullValues: const ['accountType', 'openingBalance'],
  );
  return CreateFinancialAccountCommand(
    accountType: CreateFinancialAccountCommand._read_accountType(
      json['accountType'],
    ),
    currencyCode: json['currencyCode'] as String?,
    institution: json['institution'] as String?,
    name: json['name'] as String?,
    openingBalance: json['openingBalance'] as String?,
  );
}

Map<String, dynamic> _$CreateFinancialAccountCommandToJson(
  CreateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': ?CreateFinancialAccountCommand._write_accountType(
    instance.accountType,
  ),
  'currencyCode': ?instance.currencyCode,
  'institution': ?instance.institution,
  'name': ?instance.name,
  'openingBalance': ?instance.openingBalance,
};
