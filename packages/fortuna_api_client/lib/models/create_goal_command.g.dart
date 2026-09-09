// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_goal_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoalCommand _$CreateGoalCommandFromJson(Map<String, dynamic> json) =>
    CreateGoalCommand(
      accountIds: (json['accountIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      currencyCode: json['currencyCode'] as String?,
      investmentIds: (json['investmentIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      targetAmount: (json['targetAmount'] as num?)?.toDouble(),
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
    );

Map<String, dynamic> _$CreateGoalCommandToJson(CreateGoalCommand instance) =>
    <String, dynamic>{
      'accountIds': instance.accountIds,
      'currencyCode': instance.currencyCode,
      'investmentIds': instance.investmentIds,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'targetDate': instance.targetDate?.toIso8601String(),
    };
