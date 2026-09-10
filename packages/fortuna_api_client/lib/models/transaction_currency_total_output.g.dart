// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_currency_total_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCurrencyTotalOutput _$TransactionCurrencyTotalOutputFromJson(
  Map<String, dynamic> json,
) => TransactionCurrencyTotalOutput(
  appliedRate: json['appliedRate'] as String?,
  currencyCode: json['currencyCode'] as String?,
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  displayEarning: json['displayEarning'] as String?,
  displayExpense: json['displayExpense'] as String?,
  displayNet: json['displayNet'] as String?,
  earning: json['earning'] as String?,
  expense: json['expense'] as String?,
  net: json['net'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$TransactionCurrencyTotalOutputToJson(
  TransactionCurrencyTotalOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'currencyCode': instance.currencyCode,
  'displayCurrencyCode': instance.displayCurrencyCode,
  'displayEarning': instance.displayEarning,
  'displayExpense': instance.displayExpense,
  'displayNet': instance.displayNet,
  'earning': instance.earning,
  'expense': instance.expense,
  'net': instance.net,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': _$ExchangeRateSourceEnumMap[instance.rateSource],
  'unconvertedReason': instance.unconvertedReason,
};

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};
