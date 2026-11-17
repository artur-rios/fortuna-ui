// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutput _$GoalOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'accounts',
      'createdAt',
      'currencyCode',
      'currentProgress',
      'id',
      'investments',
      'isDeleted',
      'name',
      'targetAmount',
      'targetDate',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'currentProgress',
      'id',
      'isDeleted',
      'targetAmount',
      'targetDate',
      'updatedAt',
    ],
  );
  return GoalOutput(
    accounts: !json.containsKey('accounts')
        ? null
        : GoalOutput._read_accounts(json['accounts']),
    createdAt: GoalOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : GoalOutput._read_currencyCode(json['currencyCode']),
    currentProgress: json['currentProgress'] == null
        ? null
        : GoalProgressOutput.fromJson(
            json['currentProgress'] as Map<String, dynamic>,
          ),
    id: json['id'] as String?,
    investments: !json.containsKey('investments')
        ? null
        : GoalOutput._read_investments(json['investments']),
    isDeleted: json['isDeleted'] as bool?,
    name: !json.containsKey('name')
        ? null
        : GoalOutput._read_name(json['name']),
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
    updatedAt: GoalOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$GoalOutputToJson(
  GoalOutput instance,
) => <String, dynamic>{
  if (instance.accounts case final $value?)
    'accounts': GoalOutput._write_accounts($value),
  'createdAt': ?GoalOutput._write_createdAt(instance.createdAt),
  if (instance.currencyCode case final $value?)
    'currencyCode': GoalOutput._write_currencyCode($value),
  'currentProgress': ?instance.currentProgress?.toJson(),
  'id': ?instance.id,
  if (instance.investments case final $value?)
    'investments': GoalOutput._write_investments($value),
  'isDeleted': ?instance.isDeleted,
  if (instance.name case final $value?) 'name': GoalOutput._write_name($value),
  'targetAmount': ?instance.targetAmount,
  'targetDate': ?instance.targetDate,
  'updatedAt': ?GoalOutput._write_updatedAt(instance.updatedAt),
};
