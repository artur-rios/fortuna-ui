// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressCommandOutput _$GoalProgressCommandOutputFromJson(
  Map<String, dynamic> json,
) => GoalProgressCommandOutput(
  currentAmount: (json['currentAmount'] as num?)?.toDouble(),
  isFullyConverted: json['isFullyConverted'] as bool?,
  isReached: json['isReached'] as bool?,
  proportionReached: (json['proportionReached'] as num?)?.toDouble(),
  remaining: (json['remaining'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GoalProgressCommandOutputToJson(
  GoalProgressCommandOutput instance,
) => <String, dynamic>{
  'currentAmount': instance.currentAmount,
  'isFullyConverted': instance.isFullyConverted,
  'isReached': instance.isReached,
  'proportionReached': instance.proportionReached,
  'remaining': instance.remaining,
};
