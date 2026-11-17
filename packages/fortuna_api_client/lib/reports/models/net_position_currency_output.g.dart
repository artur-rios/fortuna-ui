// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_currency_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionCurrencyOutput _$NetPositionCurrencyOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'creditCards',
      'displayNet',
      'financialAccounts',
      'investments',
      'rateDate',
      'rateSource',
      'sourceCurrencyCode',
      'sourceNet',
      'unconvertedReason',
    ],
    disallowNullValues: const [
      'creditCards',
      'financialAccounts',
      'investments',
      'sourceNet',
    ],
  );
  return NetPositionCurrencyOutput(
    appliedRate: json['appliedRate'] as String?,
    creditCards: json['creditCards'] as String?,
    displayNet: json['displayNet'] as String?,
    financialAccounts: json['financialAccounts'] as String?,
    investments: json['investments'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: NetPositionCurrencyOutput._read_rateSource(json['rateSource']),
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    sourceNet: json['sourceNet'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$NetPositionCurrencyOutputToJson(
  NetPositionCurrencyOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'creditCards': ?instance.creditCards,
  'displayNet': ?instance.displayNet,
  'financialAccounts': ?instance.financialAccounts,
  'investments': ?instance.investments,
  'rateDate': ?instance.rateDate,
  'rateSource': ?NetPositionCurrencyOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'sourceNet': ?instance.sourceNet,
  'unconvertedReason': ?instance.unconvertedReason,
};
