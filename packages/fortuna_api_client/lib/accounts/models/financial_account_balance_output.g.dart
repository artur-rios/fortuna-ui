// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_balance_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountBalanceOutput _$FinancialAccountBalanceOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['asOf', 'balance', 'currencyCode', 'id'],
    disallowNullValues: const ['asOf', 'balance', 'id'],
  );
  return FinancialAccountBalanceOutput(
    asOf: json['asOf'] as String?,
    balance: json['balance'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : FinancialAccountBalanceOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$FinancialAccountBalanceOutputToJson(
  FinancialAccountBalanceOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  'balance': ?instance.balance,
  if (instance.currencyCode case final $value?)
    'currencyCode': FinancialAccountBalanceOutput._write_currencyCode($value),
  'id': ?instance.id,
};
