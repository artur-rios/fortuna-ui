// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutput _$GoalListOutputFromJson(Map<String, dynamic> json) =>
    GoalListOutput(
      goals: (json['goals'] as List<dynamic>?)
          ?.map((e) => GoalOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GoalListOutputToJson(GoalListOutput instance) =>
    <String, dynamic>{
      'goals': instance.goals,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
    };
