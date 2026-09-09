// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommand _$CreateFinancialAccountCommandFromJson(
  Map<String, dynamic> json,
) => CreateFinancialAccountCommand(
  accountType: json['accountType'] == null
      ? null
      : FinancialAccountType.fromJson((json['accountType'] as num).toInt()),
  currencyCode: json['currencyCode'] as String?,
  institution: json['institution'] as String?,
  name: json['name'] as String?,
  openingBalance: (json['openingBalance'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CreateFinancialAccountCommandToJson(
  CreateFinancialAccountCommand instance,
) => <String, dynamic>{
  'accountType': _$FinancialAccountTypeEnumMap[instance.accountType],
  'currencyCode': instance.currencyCode,
  'institution': instance.institution,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
};

const _$FinancialAccountTypeEnumMap = {
  FinancialAccountType.value1: 1,
  FinancialAccountType.value2: 2,
  FinancialAccountType.value3: 3,
  FinancialAccountType.value4: 4,
  FinancialAccountType.$unknown: r'$unknown',
};
