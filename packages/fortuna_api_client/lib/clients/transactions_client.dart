// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/attach_document_command_output_data_output.dart';
import '../models/reconcile_transaction_command.dart';
import '../models/reconcile_transaction_command_output_data_output.dart';
import '../models/record_transaction_command.dart';
import '../models/record_transaction_command_output_data_output.dart';
import '../models/transaction_direction.dart';
import '../models/transaction_lifecycle_command_output_data_output.dart';
import '../models/transaction_output_data_output.dart';
import '../models/transaction_search_output_data_output.dart';
import '../models/transaction_tag_command_output_data_output.dart';
import '../models/update_transaction_command.dart';
import '../models/update_transaction_command_output_data_output.dart';

part 'transactions_client.g.dart';

@RestApi()
abstract class TransactionsClient {
  factory TransactionsClient(Dio dio, {String? baseUrl}) = _TransactionsClient;

  @GET('/api/transactions')
  Future<TransactionSearchOutputDataOutput> getApiTransactions({
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
    @Query('FinancialAccountId') String? financialAccountId,
    @Query('CreditCardId') String? creditCardId,
    @Query('CategoryId') String? categoryId,
    @Query('TagId') String? tagId,
    @Query('CounterpartyId') String? counterpartyId,
    @Query('Direction') TransactionDirection? direction,
    @Query('MinimumAmount') String? minimumAmount,
    @Query('MaximumAmount') String? maximumAmount,
    @Query('Text') String? text,
    @Query('IncludeDeleted') bool? includeDeleted,
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('FigureDate') DateTime? figureDate,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/transactions')
  Future<RecordTransactionCommandOutputDataOutput> postApiTransactions({
    @Body() RecordTransactionCommand? body,
  });

  @DELETE('/api/transactions/{id}')
  Future<TransactionLifecycleCommandOutputDataOutput> deleteApiTransactionsId({
    @Path('id') required String id,
  });

  @GET('/api/transactions/{id}')
  Future<TransactionOutputDataOutput> getApiTransactionsId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @PUT('/api/transactions/{id}')
  Future<UpdateTransactionCommandOutputDataOutput> putApiTransactionsId({
    @Path('id') required String id,
    @Body() UpdateTransactionCommand? body,
  });

  @MultiPart()
  @POST('/api/transactions/{id}/attachments')
  Future<AttachDocumentCommandOutputDataOutput>
  postApiTransactionsIdAttachments({
    @Path('id') required String id,
    @Part(name: 'File') File? file,
  });

  @DELETE('/api/transactions/{id}/hard')
  Future<TransactionLifecycleCommandOutputDataOutput>
  deleteApiTransactionsIdHard({@Path('id') required String id});

  @POST('/api/transactions/{id}/reconcile')
  Future<ReconcileTransactionCommandOutputDataOutput>
  postApiTransactionsIdReconcile({
    @Path('id') required String id,
    @Body() ReconcileTransactionCommand? body,
  });

  @POST('/api/transactions/{id}/restore')
  Future<TransactionLifecycleCommandOutputDataOutput>
  postApiTransactionsIdRestore({@Path('id') required String id});

  @DELETE('/api/transactions/{id}/tags/{tagId}')
  Future<TransactionTagCommandOutputDataOutput>
  deleteApiTransactionsIdTagsTagId({
    @Path('id') required String id,
    @Path('tagId') required String tagId,
  });

  @POST('/api/transactions/{id}/tags/{tagId}')
  Future<TransactionTagCommandOutputDataOutput> postApiTransactionsIdTagsTagId({
    @Path('id') required String id,
    @Path('tagId') required String tagId,
  });
}
