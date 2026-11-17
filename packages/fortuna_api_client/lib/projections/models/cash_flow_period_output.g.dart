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
    figures: !json.containsKey('figures')
        ? null
        : CashFlowPeriodOutput._read_figures(json['figures']),
    openingBalance: json['openingBalance'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
  );
}

Map<String, dynamic> _$CashFlowPeriodOutputToJson(
  CashFlowPeriodOutput instance,
) => <String, dynamic>{
  'closingBalance': ?instance.closingBalance,
  if (instance.figures case final $value?)
    'figures': CashFlowPeriodOutput._write_figures($value),
  'openingBalance': ?instance.openingBalance,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
};
