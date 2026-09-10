// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressOutput _$GoalProgressOutputFromJson(Map<String, dynamic> json) =>
    GoalProgressOutput(
      currentAmount: json['currentAmount'] as String?,
      isFullyConverted: json['isFullyConverted'] as bool?,
      isReached: json['isReached'] as bool?,
      proportionReached: json['proportionReached'] as String?,
      remaining: json['remaining'] as String?,
    );

Map<String, dynamic> _$GoalProgressOutputToJson(GoalProgressOutput instance) =>
    <String, dynamic>{
      'currentAmount': instance.currentAmount,
      'isFullyConverted': instance.isFullyConverted,
      'isReached': instance.isReached,
      'proportionReached': instance.proportionReached,
      'remaining': instance.remaining,
    };
