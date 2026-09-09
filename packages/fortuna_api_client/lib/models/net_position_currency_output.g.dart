// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_currency_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionCurrencyOutput _$NetPositionCurrencyOutputFromJson(
  Map<String, dynamic> json,
) => NetPositionCurrencyOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  creditCards: (json['creditCards'] as num?)?.toDouble(),
  displayNet: (json['displayNet'] as num?)?.toDouble(),
  financialAccounts: (json['financialAccounts'] as num?)?.toDouble(),
  investments: (json['investments'] as num?)?.toDouble(),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  sourceNet: (json['sourceNet'] as num?)?.toDouble(),
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
  'rateSource': instance.rateSource,
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'sourceNet': instance.sourceNet,
  'unconvertedReason': instance.unconvertedReason,
};
