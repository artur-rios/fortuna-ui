// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_investment_command.dart';
import '../models/create_investment_command_output_data_output.dart';
import '../models/investment_lifecycle_command_output_data_output.dart';
import '../models/investment_output_data_output.dart';
import '../models/investment_output_paginated_output.dart';
import '../models/investment_type.dart';
import '../models/investment_valuation_output_paginated_output.dart';
import '../models/record_investment_movement_command.dart';
import '../models/record_investment_movement_command_output_data_output.dart';
import '../models/record_investment_valuation_command.dart';
import '../models/record_investment_valuation_command_output_data_output.dart';
import '../models/update_investment_command.dart';
import '../models/update_investment_command_output_data_output.dart';

part 'investments_client.g.dart';

@RestApi()
abstract class InvestmentsClient {
  factory InvestmentsClient(Dio dio, {String? baseUrl}) = _InvestmentsClient;

  @GET('/api/investments')
  Future<InvestmentOutputPaginatedOutput> getApiInvestments({
    @Query('Instrument') String? instrument,
    @Query('Institution') String? institution,
    @Query('InvestmentType') InvestmentType? investmentType,
    @Query('CurrencyCode') String? currencyCode,
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('FigureDate') DateTime? figureDate,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/investments')
  Future<CreateInvestmentCommandOutputDataOutput> postApiInvestments({
    @Body() CreateInvestmentCommand? body,
  });

  @DELETE('/api/investments/{id}')
  Future<InvestmentLifecycleCommandOutputDataOutput> deleteApiInvestmentsId({
    @Path('id') required String id,
  });

  @GET('/api/investments/{id}')
  Future<InvestmentOutputDataOutput> getApiInvestmentsId({
    @Path('id') required String id,
    @Query('displayCurrencyCode') String? displayCurrencyCode,
    @Query('figureDate') DateTime? figureDate,
  });

  @PUT('/api/investments/{id}')
  Future<UpdateInvestmentCommandOutputDataOutput> putApiInvestmentsId({
    @Path('id') required String id,
    @Body() UpdateInvestmentCommand? body,
  });

  @DELETE('/api/investments/{id}/hard')
  Future<InvestmentLifecycleCommandOutputDataOutput>
  deleteApiInvestmentsIdHard({@Path('id') required String id});

  @POST('/api/investments/{id}/movements')
  Future<RecordInvestmentMovementCommandOutputDataOutput>
  postApiInvestmentsIdMovements({
    @Path('id') required String id,
    @Body() RecordInvestmentMovementCommand? body,
  });

  @POST('/api/investments/{id}/restore')
  Future<InvestmentLifecycleCommandOutputDataOutput>
  postApiInvestmentsIdRestore({@Path('id') required String id});

  @GET('/api/investments/{id}/valuations')
  Future<InvestmentValuationOutputPaginatedOutput>
  getApiInvestmentsIdValuations({
    @Path('id') required String id,
    @Query('InvestmentId') String? investmentId,
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/investments/{id}/valuations')
  Future<RecordInvestmentValuationCommandOutputDataOutput>
  postApiInvestmentsIdValuations({
    @Path('id') required String id,
    @Body() RecordInvestmentValuationCommand? body,
  });
}
