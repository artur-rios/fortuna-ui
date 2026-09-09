// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/installment_plan_lifecycle_command_output_data_output.dart';
import '../models/installment_plan_output_data_output.dart';
import '../models/record_installment_plan_command.dart';
import '../models/record_installment_plan_command_output_data_output.dart';

part 'installment_plans_client.g.dart';

@RestApi()
abstract class InstallmentPlansClient {
  factory InstallmentPlansClient(Dio dio, {String? baseUrl}) =
      _InstallmentPlansClient;

  @POST('/api/installment-plans')
  Future<RecordInstallmentPlanCommandOutputDataOutput> postApiInstallmentPlans({
    @Body() RecordInstallmentPlanCommand? body,
  });

  @DELETE('/api/installment-plans/{id}')
  Future<InstallmentPlanLifecycleCommandOutputDataOutput>
  deleteApiInstallmentPlansId({@Path('id') required String id});

  @GET('/api/installment-plans/{id}')
  Future<InstallmentPlanOutputDataOutput> getApiInstallmentPlansId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/installment-plans/{id}/restore')
  Future<InstallmentPlanLifecycleCommandOutputDataOutput>
  postApiInstallmentPlansIdRestore({@Path('id') required String id});
}
