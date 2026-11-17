// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_detail_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressDetailOutput _$GoalProgressDetailOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'asOf',
      'currencyCode',
      'currentAmount',
      'daysRemaining',
      'goalId',
      'isFullyConverted',
      'isPastDue',
      'isReached',
      'proportionReached',
      'resources',
      'shortfall',
      'targetAmount',
      'targetDate',
    ],
    disallowNullValues: const [
      'asOf',
      'daysRemaining',
      'goalId',
      'isFullyConverted',
      'targetAmount',
      'targetDate',
    ],
  );
  return GoalProgressDetailOutput(
    asOf: json['asOf'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : GoalProgressDetailOutput._read_currencyCode(json['currencyCode']),
    currentAmount: !json.containsKey('currentAmount')
        ? null
        : GoalProgressDetailOutput._read_currentAmount(json['currentAmount']),
    daysRemaining: GoalProgressDetailOutput._read_daysRemaining(
      json['daysRemaining'],
    ),
    goalId: json['goalId'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    isPastDue: !json.containsKey('isPastDue')
        ? null
        : GoalProgressDetailOutput._read_isPastDue(json['isPastDue']),
    isReached: !json.containsKey('isReached')
        ? null
        : GoalProgressDetailOutput._read_isReached(json['isReached']),
    proportionReached: !json.containsKey('proportionReached')
        ? null
        : GoalProgressDetailOutput._read_proportionReached(
            json['proportionReached'],
          ),
    resources: !json.containsKey('resources')
        ? null
        : GoalProgressDetailOutput._read_resources(json['resources']),
    shortfall: !json.containsKey('shortfall')
        ? null
        : GoalProgressDetailOutput._read_shortfall(json['shortfall']),
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
  );
}

Map<String, dynamic> _$GoalProgressDetailOutputToJson(
  GoalProgressDetailOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  if (instance.currencyCode case final $value?)
    'currencyCode': GoalProgressDetailOutput._write_currencyCode($value),
  if (instance.currentAmount case final $value?)
    'currentAmount': GoalProgressDetailOutput._write_currentAmount($value),
  'daysRemaining': ?GoalProgressDetailOutput._write_daysRemaining(
    instance.daysRemaining,
  ),
  'goalId': ?instance.goalId,
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.isPastDue case final $value?)
    'isPastDue': GoalProgressDetailOutput._write_isPastDue($value),
  if (instance.isReached case final $value?)
    'isReached': GoalProgressDetailOutput._write_isReached($value),
  if (instance.proportionReached case final $value?)
    'proportionReached': GoalProgressDetailOutput._write_proportionReached(
      $value,
    ),
  if (instance.resources case final $value?)
    'resources': GoalProgressDetailOutput._write_resources($value),
  if (instance.shortfall case final $value?)
    'shortfall': GoalProgressDetailOutput._write_shortfall($value),
  'targetAmount': ?instance.targetAmount,
  'targetDate': ?instance.targetDate,
};
