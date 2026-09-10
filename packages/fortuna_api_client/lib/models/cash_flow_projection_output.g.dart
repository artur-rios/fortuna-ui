// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_projection_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowProjectionOutput _$CashFlowProjectionOutputFromJson(
  Map<String, dynamic> json,
) => CashFlowProjectionOutput(
  asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'] as String),
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  estimateOmittedReason: json['estimateOmittedReason'] as String?,
  flatReason: json['flatReason'] as String?,
  periodicity: json['periodicity'] == null
      ? null
      : CashFlowPeriodicity.fromJson((json['periodicity'] as num).toInt()),
  periods: (json['periods'] as List<dynamic>?)
      ?.map((e) => CashFlowPeriodOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  rates: (json['rates'] as List<dynamic>?)
      ?.map((e) => CashFlowRateOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  startingBalance: json['startingBalance'] as String?,
  through: json['through'] == null
      ? null
      : DateTime.parse(json['through'] as String),
);

Map<String, dynamic> _$CashFlowProjectionOutputToJson(
  CashFlowProjectionOutput instance,
) => <String, dynamic>{
  'asOf': instance.asOf?.toIso8601String(),
  'displayCurrencyCode': instance.displayCurrencyCode,
  'estimateOmittedReason': instance.estimateOmittedReason,
  'flatReason': instance.flatReason,
  'periodicity': _$CashFlowPeriodicityEnumMap[instance.periodicity],
  'periods': instance.periods,
  'rates': instance.rates,
  'startingBalance': instance.startingBalance,
  'through': instance.through?.toIso8601String(),
};

const _$CashFlowPeriodicityEnumMap = {
  CashFlowPeriodicity.value1: 1,
  CashFlowPeriodicity.value2: 2,
  CashFlowPeriodicity.value3: 3,
  CashFlowPeriodicity.$unknown: r'$unknown',
};
