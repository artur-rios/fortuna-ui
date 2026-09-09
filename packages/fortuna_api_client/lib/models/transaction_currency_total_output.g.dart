// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_currency_total_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCurrencyTotalOutput _$TransactionCurrencyTotalOutputFromJson(
  Map<String, dynamic> json,
) => TransactionCurrencyTotalOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String?,
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  displayEarning: (json['displayEarning'] as num?)?.toDouble(),
  displayExpense: (json['displayExpense'] as num?)?.toDouble(),
  displayNet: (json['displayNet'] as num?)?.toDouble(),
  earning: (json['earning'] as num?)?.toDouble(),
  expense: (json['expense'] as num?)?.toDouble(),
  net: (json['net'] as num?)?.toDouble(),
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
  'rateSource': instance.rateSource,
  'unconvertedReason': instance.unconvertedReason,
};
