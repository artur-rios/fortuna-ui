// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/budget_command_output_data_output.dart';
import '../models/budget_consumption_detail_output_data_output.dart';
import '../models/budget_list_output_data_output.dart';
import '../models/budget_output_data_output.dart';
import '../models/create_budget_command.dart';
import '../models/update_budget_command.dart';

part 'budgets_client.g.dart';

@RestApi()
abstract class BudgetsClient {
  factory BudgetsClient(Dio dio, {String? baseUrl}) = _BudgetsClient;

  @GET('/api/budgets')
  Future<BudgetListOutputDataOutput> getApiBudgets({
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/budgets')
  Future<BudgetCommandOutputDataOutput> postApiBudgets({
    @Body() CreateBudgetCommand? body,
  });

  @DELETE('/api/budgets/{id}')
  Future<BudgetCommandOutputDataOutput> deleteApiBudgetsId({
    @Path('id') required String id,
  });

  @GET('/api/budgets/{id}')
  Future<BudgetOutputDataOutput> getApiBudgetsId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @PUT('/api/budgets/{id}')
  Future<BudgetCommandOutputDataOutput> putApiBudgetsId({
    @Path('id') required String id,
    @Body() UpdateBudgetCommand? body,
  });

  @GET('/api/budgets/{id}/consumption')
  Future<BudgetConsumptionDetailOutputDataOutput> getApiBudgetsIdConsumption({
    @Path('id') required String id,
    @Query('periodStart') DateTime? periodStart,
  });
}
