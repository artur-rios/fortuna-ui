// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommand _$UpdateFinancialAccountCommandFromJson(
  Map<String, dynamic> json,
) => UpdateFinancialAccountCommand(
  accountType: json['accountType'] == null
      ? null
      : FinancialAccountType.fromJson((json['accountType'] as num).toInt()),
  currencyCode: json['currencyCode'] as String?,
  institution: json['institution'] as String?,
  name: json['name'] as String?,
  openingBalance: json['openingBalance'] as String?,
  ownerId: json['ownerId'] as String?,
);

Map<String, dynamic> _$UpdateFinancialAccountCommandToJson(
  UpdateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': _$FinancialAccountTypeEnumMap[instance.accountType],
  'currencyCode': instance.currencyCode,
  'institution': instance.institution,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
  'ownerId': instance.ownerId,
};

const _$FinancialAccountTypeEnumMap = {
  FinancialAccountType.value1: 1,
  FinancialAccountType.value2: 2,
  FinancialAccountType.value3: 3,
  FinancialAccountType.value4: 4,
  FinancialAccountType.$unknown: r'$unknown',
};
