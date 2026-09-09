// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_financial_account_command.dart';
import '../models/create_financial_account_command_output_data_output.dart';
import '../models/financial_account_balance_output_data_output.dart';
import '../models/financial_account_lifecycle_command_output_data_output.dart';
import '../models/financial_account_output_data_output.dart';
import '../models/financial_account_output_paginated_output.dart';
import '../models/financial_account_type.dart';
import '../models/update_financial_account_command.dart';
import '../models/update_financial_account_command_output_data_output.dart';

part 'accounts_client.g.dart';

@RestApi()
abstract class AccountsClient {
  factory AccountsClient(Dio dio, {String? baseUrl}) = _AccountsClient;

  @GET('/api/accounts')
  Future<FinancialAccountOutputPaginatedOutput> getApiAccounts({
    @Query('Name') String? name,
    @Query('Institution') String? institution,
    @Query('AccountType') FinancialAccountType? accountType,
    @Query('CurrencyCode') String? currencyCode,
    @Query('IncludeDeleted') bool? includeDeleted,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/accounts')
  Future<CreateFinancialAccountCommandOutputDataOutput> postApiAccounts({
    @Body() CreateFinancialAccountCommand? body,
  });

  @DELETE('/api/accounts/{id}')
  Future<FinancialAccountLifecycleCommandOutputDataOutput> deleteApiAccountsId({
    @Path('id') required String id,
  });

  @GET('/api/accounts/{id}')
  Future<FinancialAccountOutputDataOutput> getApiAccountsId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @PUT('/api/accounts/{id}')
  Future<UpdateFinancialAccountCommandOutputDataOutput> putApiAccountsId({
    @Path('id') required String id,
    @Body() UpdateFinancialAccountCommand? body,
  });

  @GET('/api/accounts/{id}/balance')
  Future<FinancialAccountBalanceOutputDataOutput> getApiAccountsIdBalance({
    @Path('id') required String id,
    @Query('asOf') DateTime? asOf,
  });

  @DELETE('/api/accounts/{id}/hard')
  Future<FinancialAccountLifecycleCommandOutputDataOutput>
  deleteApiAccountsIdHard({@Path('id') required String id});

  @POST('/api/accounts/{id}/restore')
  Future<FinancialAccountLifecycleCommandOutputDataOutput>
  postApiAccountsIdRestore({@Path('id') required String id});
}
