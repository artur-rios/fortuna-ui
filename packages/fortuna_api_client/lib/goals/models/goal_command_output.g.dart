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
    accounts: (json['accounts'] as List<dynamic>?)
        ?.map(
          (e) => GoalResourceCommandOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    createdAt: GoalCommandOutput._read_createdAt(json['createdAt']),
    currencyCode: json['currencyCode'] as String?,
    currentProgress: json['currentProgress'] == null
        ? null
        : GoalProgressCommandOutput.fromJson(
            json['currentProgress'] as Map<String, dynamic>,
          ),
    id: json['id'] as String?,
    investments: (json['investments'] as List<dynamic>?)
        ?.map(
          (e) => GoalResourceCommandOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
    updatedAt: GoalCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$GoalCommandOutputToJson(GoalCommandOutput instance) =>
    <String, dynamic>{
      'accounts': ?instance.accounts?.map((e) => e.toJson()).toList(),
      'createdAt': ?GoalCommandOutput._write_createdAt(instance.createdAt),
      'currencyCode': ?instance.currencyCode,
      'currentProgress': ?instance.currentProgress?.toJson(),
      'id': ?instance.id,
      'investments': ?instance.investments?.map((e) => e.toJson()).toList(),
      'isDeleted': ?instance.isDeleted,
      'name': ?instance.name,
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
      'updatedAt': ?GoalCommandOutput._write_updatedAt(instance.updatedAt),
    };
