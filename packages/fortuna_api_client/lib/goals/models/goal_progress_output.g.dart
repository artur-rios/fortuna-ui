// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressOutput _$GoalProgressOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'currentAmount',
      'isFullyConverted',
      'isReached',
      'proportionReached',
      'remaining',
    ],
    disallowNullValues: const ['isFullyConverted'],
  );
  return GoalProgressOutput(
    currentAmount: !json.containsKey('currentAmount')
        ? null
        : GoalProgressOutput._read_currentAmount(json['currentAmount']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    isReached: !json.containsKey('isReached')
        ? null
        : GoalProgressOutput._read_isReached(json['isReached']),
    proportionReached: !json.containsKey('proportionReached')
        ? null
        : GoalProgressOutput._read_proportionReached(json['proportionReached']),
    remaining: !json.containsKey('remaining')
        ? null
        : GoalProgressOutput._read_remaining(json['remaining']),
  );
}

Map<String, dynamic> _$GoalProgressOutputToJson(
  GoalProgressOutput instance,
) => <String, dynamic>{
  if (instance.currentAmount case final $value?)
    'currentAmount': GoalProgressOutput._write_currentAmount($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.isReached case final $value?)
    'isReached': GoalProgressOutput._write_isReached($value),
  if (instance.proportionReached case final $value?)
    'proportionReached': GoalProgressOutput._write_proportionReached($value),
  if (instance.remaining case final $value?)
    'remaining': GoalProgressOutput._write_remaining($value),
};
