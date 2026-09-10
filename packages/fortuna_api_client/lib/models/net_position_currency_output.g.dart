// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_currency_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionCurrencyOutput _$NetPositionCurrencyOutputFromJson(
  Map<String, dynamic> json,
) => NetPositionCurrencyOutput(
  appliedRate: json['appliedRate'] as String?,
  creditCards: json['creditCards'] as String?,
  displayNet: json['displayNet'] as String?,
  financialAccounts: json['financialAccounts'] as String?,
  investments: json['investments'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  sourceNet: json['sourceNet'] as String?,
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$NetPositionCurrencyOutputToJson(
  NetPositionCurrencyOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'creditCards': instance.creditCards,
  'displayNet': instance.displayNet,
  'financialAccounts': instance.financialAccounts,
  'investments': instance.investments,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': _$ExchangeRateSourceEnumMap[instance.rateSource],
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'sourceNet': instance.sourceNet,
  'unconvertedReason': instance.unconvertedReason,
};

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};
