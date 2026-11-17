// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommand _$UpdateFinancialAccountCommandFromJson(
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
      'ownerId',
    ],
    disallowNullValues: const ['accountType'],
  );
  return UpdateFinancialAccountCommand(
    accountType: UpdateFinancialAccountCommand._read_accountType(
      json['accountType'],
    ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateFinancialAccountCommand._read_currencyCode(
            json['currencyCode'],
          ),
    institution: !json.containsKey('institution')
        ? null
        : UpdateFinancialAccountCommand._read_institution(json['institution']),
    name: !json.containsKey('name')
        ? null
        : UpdateFinancialAccountCommand._read_name(json['name']),
    openingBalance: !json.containsKey('openingBalance')
        ? null
        : UpdateFinancialAccountCommand._read_openingBalance(
            json['openingBalance'],
          ),
    ownerId: !json.containsKey('ownerId')
        ? null
        : UpdateFinancialAccountCommand._read_ownerId(json['ownerId']),
  );
}

Map<String, dynamic> _$UpdateFinancialAccountCommandToJson(
  UpdateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': ?UpdateFinancialAccountCommand._write_accountType(
    instance.accountType,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateFinancialAccountCommand._write_currencyCode($value),
  if (instance.institution case final $value?)
    'institution': UpdateFinancialAccountCommand._write_institution($value),
  if (instance.name case final $value?)
    'name': UpdateFinancialAccountCommand._write_name($value),
  if (instance.openingBalance case final $value?)
    'openingBalance': UpdateFinancialAccountCommand._write_openingBalance(
      $value,
    ),
  if (instance.ownerId case final $value?)
    'ownerId': UpdateFinancialAccountCommand._write_ownerId($value),
};
