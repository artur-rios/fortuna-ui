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
      'updatedAt',
    ],
  );
  return InvestmentOutput(
    appliedRate: json['appliedRate'] as String?,
    createdAt: InvestmentOutput._read_createdAt(json['createdAt']),
    currencyCode: json['currencyCode'] as String?,
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    displayPosition: json['displayPosition'] as String?,
    id: json['id'] as String?,
    institution: json['institution'] as String?,
    instrument: json['instrument'] as String?,
    investmentType: InvestmentOutput._read_investmentType(
      json['investmentType'],
    ),
    isDeleted: json['isDeleted'] as bool?,
    isIndependentlyValued: json['isIndependentlyValued'] as bool?,
    latestValuationDate: json['latestValuationDate'] as String?,
    latestValuationValue: json['latestValuationValue'] as String?,
    position: json['position'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: InvestmentOutput._read_rateSource(json['rateSource']),
    unconvertedReason: json['unconvertedReason'] as String?,
    updatedAt: InvestmentOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$InvestmentOutputToJson(InvestmentOutput instance) =>
    <String, dynamic>{
      'appliedRate': ?instance.appliedRate,
      'createdAt': ?InvestmentOutput._write_createdAt(instance.createdAt),
      'currencyCode': ?instance.currencyCode,
      'displayCurrencyCode': ?instance.displayCurrencyCode,
      'displayPosition': ?instance.displayPosition,
      'id': ?instance.id,
      'institution': ?instance.institution,
      'instrument': ?instance.instrument,
      'investmentType': ?InvestmentOutput._write_investmentType(
        instance.investmentType,
      ),
      'isDeleted': ?instance.isDeleted,
      'isIndependentlyValued': ?instance.isIndependentlyValued,
      'latestValuationDate': ?instance.latestValuationDate,
      'latestValuationValue': ?instance.latestValuationValue,
      'position': ?instance.position,
      'rateDate': ?instance.rateDate,
      'rateSource': ?InvestmentOutput._write_rateSource(instance.rateSource),
      'unconvertedReason': ?instance.unconvertedReason,
      'updatedAt': ?InvestmentOutput._write_updatedAt(instance.updatedAt),
    };
