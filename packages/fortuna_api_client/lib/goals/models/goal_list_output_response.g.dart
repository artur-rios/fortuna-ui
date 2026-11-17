// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutput$Response _$GoalListOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'goals',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
  );
  return GoalListOutput$Response(
    goals: !json.containsKey('goals')
        ? null
        : GoalListOutput$Response._read_goals(json['goals']),
    pageNumber: GoalListOutput$Response._read_pageNumber(json['pageNumber']),
    pageSize: GoalListOutput$Response._read_pageSize(json['pageSize']),
    totalItems: GoalListOutput$Response._read_totalItems(json['totalItems']),
    totalPages: GoalListOutput$Response._read_totalPages(json['totalPages']),
  );
}

Map<String, dynamic> _$GoalListOutput$ResponseToJson(
  GoalListOutput$Response instance,
) => <String, dynamic>{
  if (instance.goals case final $value?)
    'goals': GoalListOutput$Response._write_goals($value),
  'pageNumber': ?GoalListOutput$Response._write_pageNumber(instance.pageNumber),
  'pageSize': ?GoalListOutput$Response._write_pageSize(instance.pageSize),
  'totalItems': ?GoalListOutput$Response._write_totalItems(instance.totalItems),
  'totalPages': ?GoalListOutput$Response._write_totalPages(instance.totalPages),
};
