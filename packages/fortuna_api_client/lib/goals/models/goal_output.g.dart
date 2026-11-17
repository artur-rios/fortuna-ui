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
    accounts: (json['accounts'] as List<dynamic>?)
        ?.map((e) => GoalResourceOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: GoalOutput._read_createdAt(json['createdAt']),
    currencyCode: json['currencyCode'] as String?,
    currentProgress: json['currentProgress'] == null
        ? null
        : GoalProgressOutput.fromJson(
            json['currentProgress'] as Map<String, dynamic>,
          ),
    id: json['id'] as String?,
    investments: (json['investments'] as List<dynamic>?)
        ?.map((e) => GoalResourceOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
    updatedAt: GoalOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$GoalOutputToJson(GoalOutput instance) =>
    <String, dynamic>{
      'accounts': ?instance.accounts?.map((e) => e.toJson()).toList(),
      'createdAt': ?GoalOutput._write_createdAt(instance.createdAt),
      'currencyCode': ?instance.currencyCode,
      'currentProgress': ?instance.currentProgress?.toJson(),
      'id': ?instance.id,
      'investments': ?instance.investments?.map((e) => e.toJson()).toList(),
      'isDeleted': ?instance.isDeleted,
      'name': ?instance.name,
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
      'updatedAt': ?GoalOutput._write_updatedAt(instance.updatedAt),
    };
