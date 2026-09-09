// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/cash_flow_periodicity.dart';
import '../models/cash_flow_projection_output_data_output.dart';
import '../models/committed_obligation_list_output_data_output.dart';

part 'projections_client.g.dart';

@RestApi()
abstract class ProjectionsClient {
  factory ProjectionsClient(Dio dio, {String? baseUrl}) = _ProjectionsClient;

  @GET('/api/projections/cash-flow')
  Future<CashFlowProjectionOutputDataOutput> getApiProjectionsCashFlow({
    @Query('HorizonDays') int? horizonDays,
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('IncludeEstimate') bool? includeEstimate,
    @Query('Periodicity') CashFlowPeriodicity? periodicity,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @GET('/api/projections/commitments')
  Future<CommittedObligationListOutputDataOutput> getApiProjectionsCommitments({
    @Query('HorizonDays') int? horizonDays,
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });
}
