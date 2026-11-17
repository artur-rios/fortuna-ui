// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalCommandOutput _$GoalCommandOutputFromJson(Map<String, dynamic> json) {
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
  return GoalCommandOutput(
    accounts: !json.containsKey('accounts')
        ? null
        : GoalCommandOutput._read_accounts(json['accounts']),
    createdAt: GoalCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : GoalCommandOutput._read_currencyCode(json['currencyCode']),
    currentProgress: json['currentProgress'] == null
        ? null
        : GoalProgressCommandOutput.fromJson(
            json['currentProgress'] as Map<String, dynamic>,
          ),
    id: json['id'] as String?,
    investments: !json.containsKey('investments')
        ? null
        : GoalCommandOutput._read_investments(json['investments']),
    isDeleted: json['isDeleted'] as bool?,
    name: !json.containsKey('name')
        ? null
        : GoalCommandOutput._read_name(json['name']),
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
    updatedAt: GoalCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$GoalCommandOutputToJson(GoalCommandOutput instance) =>
    <String, dynamic>{
      if (instance.accounts case final $value?)
        'accounts': GoalCommandOutput._write_accounts($value),
      'createdAt': ?GoalCommandOutput._write_createdAt(instance.createdAt),
      if (instance.currencyCode case final $value?)
        'currencyCode': GoalCommandOutput._write_currencyCode($value),
      'currentProgress': ?instance.currentProgress?.toJson(),
      'id': ?instance.id,
      if (instance.investments case final $value?)
        'investments': GoalCommandOutput._write_investments($value),
      'isDeleted': ?instance.isDeleted,
      if (instance.name case final $value?)
        'name': GoalCommandOutput._write_name($value),
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
      'updatedAt': ?GoalCommandOutput._write_updatedAt(instance.updatedAt),
    };
