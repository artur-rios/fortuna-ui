// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutput _$GoalOutputFromJson(Map<String, dynamic> json) => GoalOutput(
  accounts: (json['accounts'] as List<dynamic>?)
      ?.map((e) => GoalResourceOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
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
  targetDate: json['targetDate'] == null
      ? null
      : DateTime.parse(json['targetDate'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$GoalOutputToJson(GoalOutput instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'createdAt': instance.createdAt?.toIso8601String(),
      'currencyCode': instance.currencyCode,
      'currentProgress': instance.currentProgress,
      'id': instance.id,
      'investments': instance.investments,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'targetDate': instance.targetDate?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
