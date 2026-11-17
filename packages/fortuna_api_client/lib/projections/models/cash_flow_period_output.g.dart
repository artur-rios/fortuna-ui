// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_period_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowPeriodOutput _$CashFlowPeriodOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'closingBalance',
      'figures',
      'openingBalance',
      'periodEnd',
      'periodStart',
    ],
    disallowNullValues: const [
      'closingBalance',
      'openingBalance',
      'periodEnd',
      'periodStart',
    ],
  );
  return CashFlowPeriodOutput(
    closingBalance: json['closingBalance'] as String?,
    figures: (json['figures'] as List<dynamic>?)
        ?.map((e) => CashFlowFigureOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    openingBalance: json['openingBalance'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
  );
}

Map<String, dynamic> _$CashFlowPeriodOutputToJson(
  CashFlowPeriodOutput instance,
) => <String, dynamic>{
  'closingBalance': ?instance.closingBalance,
  'figures': ?instance.figures?.map((e) => e.toJson()).toList(),
  'openingBalance': ?instance.openingBalance,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
};
