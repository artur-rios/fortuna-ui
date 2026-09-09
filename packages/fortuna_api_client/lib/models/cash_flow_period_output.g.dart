// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_period_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowPeriodOutput _$CashFlowPeriodOutputFromJson(
  Map<String, dynamic> json,
) => CashFlowPeriodOutput(
  closingBalance: (json['closingBalance'] as num?)?.toDouble(),
  figures: (json['figures'] as List<dynamic>?)
      ?.map((e) => CashFlowFigureOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  openingBalance: (json['openingBalance'] as num?)?.toDouble(),
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
);

Map<String, dynamic> _$CashFlowPeriodOutputToJson(
  CashFlowPeriodOutput instance,
) => <String, dynamic>{
  'closingBalance': instance.closingBalance,
  'figures': instance.figures,
  'openingBalance': instance.openingBalance,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
};
