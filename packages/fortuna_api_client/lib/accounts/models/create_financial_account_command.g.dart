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
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateFinancialAccountCommand._read_currencyCode(
            json['currencyCode'],
          ),
    institution: !json.containsKey('institution')
        ? null
        : CreateFinancialAccountCommand._read_institution(json['institution']),
    name: !json.containsKey('name')
        ? null
        : CreateFinancialAccountCommand._read_name(json['name']),
    openingBalance: json['openingBalance'] as String?,
  );
}

Map<String, dynamic> _$CreateFinancialAccountCommandToJson(
  CreateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': ?CreateFinancialAccountCommand._write_accountType(
    instance.accountType,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateFinancialAccountCommand._write_currencyCode($value),
  if (instance.institution case final $value?)
    'institution': CreateFinancialAccountCommand._write_institution($value),
  if (instance.name case final $value?)
    'name': CreateFinancialAccountCommand._write_name($value),
  'openingBalance': ?instance.openingBalance,
};
