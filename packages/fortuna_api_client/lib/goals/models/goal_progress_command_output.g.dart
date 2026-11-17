// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressCommandOutput _$GoalProgressCommandOutputFromJson(
  Map<String, dynamic> json,
) {
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
  return GoalProgressCommandOutput(
    currentAmount: !json.containsKey('currentAmount')
        ? null
        : GoalProgressCommandOutput._read_currentAmount(json['currentAmount']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    isReached: !json.containsKey('isReached')
        ? null
        : GoalProgressCommandOutput._read_isReached(json['isReached']),
    proportionReached: !json.containsKey('proportionReached')
        ? null
        : GoalProgressCommandOutput._read_proportionReached(
            json['proportionReached'],
          ),
    remaining: !json.containsKey('remaining')
        ? null
        : GoalProgressCommandOutput._read_remaining(json['remaining']),
  );
}

Map<String, dynamic> _$GoalProgressCommandOutputToJson(
  GoalProgressCommandOutput instance,
) => <String, dynamic>{
  if (instance.currentAmount case final $value?)
    'currentAmount': GoalProgressCommandOutput._write_currentAmount($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.isReached case final $value?)
    'isReached': GoalProgressCommandOutput._write_isReached($value),
  if (instance.proportionReached case final $value?)
    'proportionReached': GoalProgressCommandOutput._write_proportionReached(
      $value,
    ),
  if (instance.remaining case final $value?)
    'remaining': GoalProgressCommandOutput._write_remaining($value),
};
