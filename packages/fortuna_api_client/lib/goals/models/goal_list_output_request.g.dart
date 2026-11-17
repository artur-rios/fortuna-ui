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
    goals: (json['goals'] as List<dynamic>?)
        ?.map((e) => GoalOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    pageNumber: GoalListOutput$Request._read_pageNumber(json['pageNumber']),
    pageSize: GoalListOutput$Request._read_pageSize(json['pageSize']),
    totalItems: GoalListOutput$Request._read_totalItems(json['totalItems']),
  );
}

Map<String, dynamic> _$GoalListOutput$RequestToJson(
  GoalListOutput$Request instance,
) => <String, dynamic>{
  'goals': ?instance.goals?.map((e) => e.toJson()).toList(),
  'pageNumber': ?GoalListOutput$Request._write_pageNumber(instance.pageNumber),
  'pageSize': ?GoalListOutput$Request._write_pageSize(instance.pageSize),
  'totalItems': ?GoalListOutput$Request._write_totalItems(instance.totalItems),
};
