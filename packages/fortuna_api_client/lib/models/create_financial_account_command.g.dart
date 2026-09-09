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
  'accountType': instance.accountType,
  'currencyCode': instance.currencyCode,
  'institution': instance.institution,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
};
