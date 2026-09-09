// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_credit_card_command.dart';
import '../models/create_credit_card_command_output_data_output.dart';
import '../models/credit_card_lifecycle_command_output_data_output.dart';
import '../models/credit_card_output_data_output.dart';
import '../models/credit_card_output_paginated_output.dart';
import '../models/credit_card_statement_output_paginated_output.dart';
import '../models/credit_card_statement_status.dart';
import '../models/update_credit_card_command.dart';
import '../models/update_credit_card_command_output_data_output.dart';

part 'credit_cards_client.g.dart';

@RestApi()
abstract class CreditCardsClient {
  factory CreditCardsClient(Dio dio, {String? baseUrl}) = _CreditCardsClient;

  @GET('/api/credit-cards')
  Future<CreditCardOutputPaginatedOutput> getApiCreditCards({
    @Query('Name') String? name,
    @Query('Issuer') String? issuer,
    @Query('CurrencyCode') String? currencyCode,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/credit-cards')
  Future<CreateCreditCardCommandOutputDataOutput> postApiCreditCards({
    @Body() CreateCreditCardCommand? body,
  });

  @DELETE('/api/credit-cards/{id}')
  Future<CreditCardLifecycleCommandOutputDataOutput> deleteApiCreditCardsId({
    @Path('id') required String id,
  });

  @GET('/api/credit-cards/{id}')
  Future<CreditCardOutputDataOutput> getApiCreditCardsId({
    @Path('id') required String id,
  });

  @PUT('/api/credit-cards/{id}')
  Future<UpdateCreditCardCommandOutputDataOutput> putApiCreditCardsId({
    @Path('id') required String id,
    @Body() UpdateCreditCardCommand? body,
  });

  @DELETE('/api/credit-cards/{id}/hard')
  Future<CreditCardLifecycleCommandOutputDataOutput>
  deleteApiCreditCardsIdHard({@Path('id') required String id});

  @POST('/api/credit-cards/{id}/restore')
  Future<CreditCardLifecycleCommandOutputDataOutput>
  postApiCreditCardsIdRestore({@Path('id') required String id});

  @GET('/api/credit-cards/{id}/statements')
  Future<CreditCardStatementOutputPaginatedOutput>
  getApiCreditCardsIdStatements({
    @Path('id') required String id,
    @Query('Status') CreditCardStatementStatus? status,
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });
}
