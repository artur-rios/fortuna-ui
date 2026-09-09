// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_detail_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressDetailOutput _$GoalProgressDetailOutputFromJson(
  Map<String, dynamic> json,
) => GoalProgressDetailOutput(
  asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'] as String),
  currencyCode: json['currencyCode'] as String?,
  currentAmount: (json['currentAmount'] as num?)?.toDouble(),
  daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
  goalId: json['goalId'] as String?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  isPastDue: json['isPastDue'] as bool?,
  isReached: json['isReached'] as bool?,
  proportionReached: (json['proportionReached'] as num?)?.toDouble(),
  resources: (json['resources'] as List<dynamic>?)
      ?.map(
        (e) => GoalResourceProgressOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  shortfall: (json['shortfall'] as num?)?.toDouble(),
  targetAmount: (json['targetAmount'] as num?)?.toDouble(),
  targetDate: json['targetDate'] == null
      ? null
      : DateTime.parse(json['targetDate'] as String),
);

Map<String, dynamic> _$GoalProgressDetailOutputToJson(
  GoalProgressDetailOutput instance,
) => <String, dynamic>{
  'asOf': instance.asOf?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'currentAmount': instance.currentAmount,
  'daysRemaining': instance.daysRemaining,
  'goalId': instance.goalId,
  'isFullyConverted': instance.isFullyConverted,
  'isPastDue': instance.isPastDue,
  'isReached': instance.isReached,
  'proportionReached': instance.proportionReached,
  'resources': instance.resources,
  'shortfall': instance.shortfall,
  'targetAmount': instance.targetAmount,
  'targetDate': instance.targetDate?.toIso8601String(),
};
