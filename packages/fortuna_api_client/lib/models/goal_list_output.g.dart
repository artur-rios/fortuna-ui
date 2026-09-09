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
    );

Map<String, dynamic> _$GoalListOutputToJson(GoalListOutput instance) =>
    <String, dynamic>{'goals': instance.goals};
