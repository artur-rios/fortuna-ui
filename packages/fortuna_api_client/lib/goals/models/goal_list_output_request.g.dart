// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutput$Request _$GoalListOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['goals', 'pageNumber', 'pageSize', 'totalItems'],
    disallowNullValues: const ['pageNumber', 'pageSize', 'totalItems'],
  );
  return GoalListOutput$Request(
    goals: !json.containsKey('goals')
        ? null
        : GoalListOutput$Request._read_goals(json['goals']),
    pageNumber: GoalListOutput$Request._read_pageNumber(json['pageNumber']),
    pageSize: GoalListOutput$Request._read_pageSize(json['pageSize']),
    totalItems: GoalListOutput$Request._read_totalItems(json['totalItems']),
  );
}

Map<String, dynamic> _$GoalListOutput$RequestToJson(
  GoalListOutput$Request instance,
) => <String, dynamic>{
  if (instance.goals case final $value?)
    'goals': GoalListOutput$Request._write_goals($value),
  'pageNumber': ?GoalListOutput$Request._write_pageNumber(instance.pageNumber),
  'pageSize': ?GoalListOutput$Request._write_pageSize(instance.pageSize),
  'totalItems': ?GoalListOutput$Request._write_totalItems(instance.totalItems),
};
