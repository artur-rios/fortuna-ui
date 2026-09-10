// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_balance_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountBalanceOutput _$FinancialAccountBalanceOutputFromJson(
  Map<String, dynamic> json,
) => FinancialAccountBalanceOutput(
  asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'] as String),
  balance: json['balance'] as String?,
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$FinancialAccountBalanceOutputToJson(
  FinancialAccountBalanceOutput instance,
) => <String, dynamic>{
  'asOf': instance.asOf?.toIso8601String(),
  'balance': instance.balance,
  'currencyCode': instance.currencyCode,
  'id': instance.id,
};
