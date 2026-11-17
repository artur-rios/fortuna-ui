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
    currencyCode: json['currencyCode'] as String?,
    currentAmount: json['currentAmount'] as String?,
    daysRemaining: GoalProgressDetailOutput._read_daysRemaining(
      json['daysRemaining'],
    ),
    goalId: json['goalId'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    isPastDue: json['isPastDue'] as bool?,
    isReached: json['isReached'] as bool?,
    proportionReached: json['proportionReached'] as String?,
    resources: (json['resources'] as List<dynamic>?)
        ?.map(
          (e) => GoalResourceProgressOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    shortfall: json['shortfall'] as String?,
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
  );
}

Map<String, dynamic> _$GoalProgressDetailOutputToJson(
  GoalProgressDetailOutput instance,
) => <String, dynamic>{
  'asOf': ?instance.asOf,
  'currencyCode': ?instance.currencyCode,
  'currentAmount': ?instance.currentAmount,
  'daysRemaining': ?GoalProgressDetailOutput._write_daysRemaining(
    instance.daysRemaining,
  ),
  'goalId': ?instance.goalId,
  'isFullyConverted': ?instance.isFullyConverted,
  'isPastDue': ?instance.isPastDue,
  'isReached': ?instance.isReached,
  'proportionReached': ?instance.proportionReached,
  'resources': ?instance.resources?.map((e) => e.toJson()).toList(),
  'shortfall': ?instance.shortfall,
  'targetAmount': ?instance.targetAmount,
  'targetDate': ?instance.targetDate,
};
