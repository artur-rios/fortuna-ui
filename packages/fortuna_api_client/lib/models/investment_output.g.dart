// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutput _$InvestmentOutputFromJson(Map<String, dynamic> json) =>
    InvestmentOutput(
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      displayCurrencyCode: json['displayCurrencyCode'] as String?,
      displayPosition: (json['displayPosition'] as num?)?.toDouble(),
      id: json['id'] as String?,
      institution: json['institution'] as String?,
      instrument: json['instrument'] as String?,
      investmentType: json['investmentType'] == null
          ? null
          : InvestmentType.fromJson((json['investmentType'] as num).toInt()),
      isIndependentlyValued: json['isIndependentlyValued'] as bool?,
      latestValuationDate: json['latestValuationDate'] == null
          ? null
          : DateTime.parse(json['latestValuationDate'] as String),
      latestValuationValue: (json['latestValuationValue'] as num?)?.toDouble(),
      position: (json['position'] as num?)?.toDouble(),
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      rateSource: json['rateSource'] == null
          ? null
          : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
      unconvertedReason: json['unconvertedReason'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InvestmentOutputToJson(InvestmentOutput instance) =>
    <String, dynamic>{
      'appliedRate': instance.appliedRate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'currencyCode': instance.currencyCode,
      'displayCurrencyCode': instance.displayCurrencyCode,
      'displayPosition': instance.displayPosition,
      'id': instance.id,
      'institution': instance.institution,
      'instrument': instance.instrument,
      'investmentType': _$InvestmentTypeEnumMap[instance.investmentType],
      'isIndependentlyValued': instance.isIndependentlyValued,
      'latestValuationDate': instance.latestValuationDate?.toIso8601String(),
      'latestValuationValue': instance.latestValuationValue,
      'position': instance.position,
      'rateDate': instance.rateDate?.toIso8601String(),
      'rateSource': _$ExchangeRateSourceEnumMap[instance.rateSource],
      'unconvertedReason': instance.unconvertedReason,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$InvestmentTypeEnumMap = {
  InvestmentType.value1: 1,
  InvestmentType.value2: 2,
  InvestmentType.value3: 3,
  InvestmentType.value4: 4,
  InvestmentType.$unknown: r'$unknown',
};

const _$ExchangeRateSourceEnumMap = {
  ExchangeRateSource.value1: 1,
  ExchangeRateSource.value2: 2,
  ExchangeRateSource.$unknown: r'$unknown',
};
