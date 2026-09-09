// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_goal_command.dart';
import '../models/goal_command_output_data_output.dart';
import '../models/goal_list_output_data_output.dart';
import '../models/goal_output_data_output.dart';
import '../models/goal_progress_detail_output_data_output.dart';
import '../models/update_goal_command.dart';

part 'goals_client.g.dart';

@RestApi()
abstract class GoalsClient {
  factory GoalsClient(Dio dio, {String? baseUrl}) = _GoalsClient;

  @GET('/api/goals')
  Future<GoalListOutputDataOutput> getApiGoals({
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/goals')
  Future<GoalCommandOutputDataOutput> postApiGoals({
    @Body() CreateGoalCommand? body,
  });

  @DELETE('/api/goals/{id}')
  Future<GoalCommandOutputDataOutput> deleteApiGoalsId({
    @Path('id') required String id,
  });

  @GET('/api/goals/{id}')
  Future<GoalOutputDataOutput> getApiGoalsId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @PUT('/api/goals/{id}')
  Future<GoalCommandOutputDataOutput> putApiGoalsId({
    @Path('id') required String id,
    @Body() UpdateGoalCommand? body,
  });

  @GET('/api/goals/{id}/progress')
  Future<GoalProgressDetailOutputDataOutput> getApiGoalsIdProgress({
    @Path('id') required String id,
  });
}
