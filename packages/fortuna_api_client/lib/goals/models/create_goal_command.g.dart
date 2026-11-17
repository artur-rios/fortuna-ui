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
    accountIds: !json.containsKey('accountIds')
        ? null
        : CreateGoalCommand._read_accountIds(json['accountIds']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateGoalCommand._read_currencyCode(json['currencyCode']),
    investmentIds: !json.containsKey('investmentIds')
        ? null
        : CreateGoalCommand._read_investmentIds(json['investmentIds']),
    name: !json.containsKey('name')
        ? null
        : CreateGoalCommand._read_name(json['name']),
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
  );
}

Map<String, dynamic> _$CreateGoalCommandToJson(CreateGoalCommand instance) =>
    <String, dynamic>{
      if (instance.accountIds case final $value?)
        'accountIds': CreateGoalCommand._write_accountIds($value),
      if (instance.currencyCode case final $value?)
        'currencyCode': CreateGoalCommand._write_currencyCode($value),
      if (instance.investmentIds case final $value?)
        'investmentIds': CreateGoalCommand._write_investmentIds($value),
      if (instance.name case final $value?)
        'name': CreateGoalCommand._write_name($value),
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
    };
