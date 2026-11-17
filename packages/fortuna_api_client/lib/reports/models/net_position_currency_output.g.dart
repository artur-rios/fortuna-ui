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
      'rateSource',
      'sourceNet',
    ],
  );
  return NetPositionCurrencyOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : NetPositionCurrencyOutput._read_appliedRate(json['appliedRate']),
    creditCards: json['creditCards'] as String?,
    displayNet: !json.containsKey('displayNet')
        ? null
        : NetPositionCurrencyOutput._read_displayNet(json['displayNet']),
    financialAccounts: json['financialAccounts'] as String?,
    investments: json['investments'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : NetPositionCurrencyOutput._read_rateDate(json['rateDate']),
    rateSource: NetPositionCurrencyOutput._read_rateSource(json['rateSource']),
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : NetPositionCurrencyOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    sourceNet: json['sourceNet'] as String?,
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : NetPositionCurrencyOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$NetPositionCurrencyOutputToJson(
  NetPositionCurrencyOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': NetPositionCurrencyOutput._write_appliedRate($value),
  'creditCards': ?instance.creditCards,
  if (instance.displayNet case final $value?)
    'displayNet': NetPositionCurrencyOutput._write_displayNet($value),
  'financialAccounts': ?instance.financialAccounts,
  'investments': ?instance.investments,
  if (instance.rateDate case final $value?)
    'rateDate': NetPositionCurrencyOutput._write_rateDate($value),
  'rateSource': ?NetPositionCurrencyOutput._write_rateSource(
    instance.rateSource,
  ),
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode': NetPositionCurrencyOutput._write_sourceCurrencyCode(
      $value,
    ),
  'sourceNet': ?instance.sourceNet,
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': NetPositionCurrencyOutput._write_unconvertedReason(
      $value,
    ),
};
