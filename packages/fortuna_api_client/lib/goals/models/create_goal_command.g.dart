// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_goal_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoalCommand _$CreateGoalCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'accountIds',
      'currencyCode',
      'investmentIds',
      'name',
      'targetAmount',
      'targetDate',
    ],
    disallowNullValues: const ['targetAmount', 'targetDate'],
  );
  return CreateGoalCommand(
    accountIds: (json['accountIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    currencyCode: json['currencyCode'] as String?,
    investmentIds: (json['investmentIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    name: json['name'] as String?,
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
  );
}

Map<String, dynamic> _$CreateGoalCommandToJson(CreateGoalCommand instance) =>
    <String, dynamic>{
      'accountIds': ?instance.accountIds,
      'currencyCode': ?instance.currencyCode,
      'investmentIds': ?instance.investmentIds,
      'name': ?instance.name,
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
    };
