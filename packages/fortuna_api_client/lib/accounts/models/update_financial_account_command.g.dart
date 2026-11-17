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
    currencyCode: json['currencyCode'] as String?,
    institution: json['institution'] as String?,
    name: json['name'] as String?,
    openingBalance: json['openingBalance'] as String?,
    ownerId: json['ownerId'] as String?,
  );
}

Map<String, dynamic> _$UpdateFinancialAccountCommandToJson(
  UpdateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': ?UpdateFinancialAccountCommand._write_accountType(
    instance.accountType,
  ),
  'currencyCode': ?instance.currencyCode,
  'institution': ?instance.institution,
  'name': ?instance.name,
  'openingBalance': ?instance.openingBalance,
  'ownerId': ?instance.ownerId,
};
