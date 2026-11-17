// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutput _$InvestmentOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'createdAt',
      'currencyCode',
      'displayCurrencyCode',
      'displayPosition',
      'id',
      'institution',
      'instrument',
      'investmentType',
      'isDeleted',
      'isIndependentlyValued',
      'latestValuationDate',
      'latestValuationValue',
      'position',
      'rateDate',
      'rateSource',
      'unconvertedReason',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'investmentType',
      'isDeleted',
      'isIndependentlyValued',
      'position',
      'rateSource',
      'updatedAt',
    ],
  );
  return InvestmentOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : InvestmentOutput._read_appliedRate(json['appliedRate']),
    createdAt: InvestmentOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : InvestmentOutput._read_currencyCode(json['currencyCode']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : InvestmentOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    displayPosition: !json.containsKey('displayPosition')
        ? null
        : InvestmentOutput._read_displayPosition(json['displayPosition']),
    id: json['id'] as String?,
    institution: !json.containsKey('institution')
        ? null
        : InvestmentOutput._read_institution(json['institution']),
    instrument: !json.containsKey('instrument')
        ? null
        : InvestmentOutput._read_instrument(json['instrument']),
    investmentType: InvestmentOutput._read_investmentType(
      json['investmentType'],
    ),
    isDeleted: json['isDeleted'] as bool?,
    isIndependentlyValued: json['isIndependentlyValued'] as bool?,
    latestValuationDate: !json.containsKey('latestValuationDate')
        ? null
        : InvestmentOutput._read_latestValuationDate(
            json['latestValuationDate'],
          ),
    latestValuationValue: !json.containsKey('latestValuationValue')
        ? null
        : InvestmentOutput._read_latestValuationValue(
            json['latestValuationValue'],
          ),
    position: json['position'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : InvestmentOutput._read_rateDate(json['rateDate']),
    rateSource: InvestmentOutput._read_rateSource(json['rateSource']),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : InvestmentOutput._read_unconvertedReason(json['unconvertedReason']),
    updatedAt: InvestmentOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$InvestmentOutputToJson(
  InvestmentOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': InvestmentOutput._write_appliedRate($value),
  'createdAt': ?InvestmentOutput._write_createdAt(instance.createdAt),
  if (instance.currencyCode case final $value?)
    'currencyCode': InvestmentOutput._write_currencyCode($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': InvestmentOutput._write_displayCurrencyCode($value),
  if (instance.displayPosition case final $value?)
    'displayPosition': InvestmentOutput._write_displayPosition($value),
  'id': ?instance.id,
  if (instance.institution case final $value?)
    'institution': InvestmentOutput._write_institution($value),
  if (instance.instrument case final $value?)
    'instrument': InvestmentOutput._write_instrument($value),
  'investmentType': ?InvestmentOutput._write_investmentType(
    instance.investmentType,
  ),
  'isDeleted': ?instance.isDeleted,
  'isIndependentlyValued': ?instance.isIndependentlyValued,
  if (instance.latestValuationDate case final $value?)
    'latestValuationDate': InvestmentOutput._write_latestValuationDate($value),
  if (instance.latestValuationValue case final $value?)
    'latestValuationValue': InvestmentOutput._write_latestValuationValue(
      $value,
    ),
  'position': ?instance.position,
  if (instance.rateDate case final $value?)
    'rateDate': InvestmentOutput._write_rateDate($value),
  'rateSource': ?InvestmentOutput._write_rateSource(instance.rateSource),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': InvestmentOutput._write_unconvertedReason($value),
  'updatedAt': ?InvestmentOutput._write_updatedAt(instance.updatedAt),
};
