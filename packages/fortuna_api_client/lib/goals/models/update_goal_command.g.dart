// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_goal_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateGoalCommand _$UpdateGoalCommandFromJson(Map<String, dynamic> json) {
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
  return UpdateGoalCommand(
    accountIds: !json.containsKey('accountIds')
        ? null
        : UpdateGoalCommand._read_accountIds(json['accountIds']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateGoalCommand._read_currencyCode(json['currencyCode']),
    investmentIds: !json.containsKey('investmentIds')
        ? null
        : UpdateGoalCommand._read_investmentIds(json['investmentIds']),
    name: !json.containsKey('name')
        ? null
        : UpdateGoalCommand._read_name(json['name']),
    targetAmount: json['targetAmount'] as String?,
    targetDate: json['targetDate'] as String?,
  );
}

Map<String, dynamic> _$UpdateGoalCommandToJson(UpdateGoalCommand instance) =>
    <String, dynamic>{
      if (instance.accountIds case final $value?)
        'accountIds': UpdateGoalCommand._write_accountIds($value),
      if (instance.currencyCode case final $value?)
        'currencyCode': UpdateGoalCommand._write_currencyCode($value),
      if (instance.investmentIds case final $value?)
        'investmentIds': UpdateGoalCommand._write_investmentIds($value),
      if (instance.name case final $value?)
        'name': UpdateGoalCommand._write_name($value),
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate,
    };
