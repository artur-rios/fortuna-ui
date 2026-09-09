// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/define_recurring_transaction_command.dart';
import '../models/define_recurring_transaction_command_output_data_output.dart';
import '../models/materialize_recurring_transactions_command.dart';
import '../models/materialize_recurring_transactions_command_output_data_output.dart';
import '../models/recurring_transaction_lifecycle_command_output_data_output.dart';
import '../models/recurring_transaction_output_data_output.dart';
import '../models/update_recurring_transaction_command.dart';
import '../models/update_recurring_transaction_command_output_data_output.dart';

part 'recurring_transactions_client.g.dart';

@RestApi()
abstract class RecurringTransactionsClient {
  factory RecurringTransactionsClient(Dio dio, {String? baseUrl}) =
      _RecurringTransactionsClient;

  @POST('/api/recurring-transactions')
  Future<DefineRecurringTransactionCommandOutputDataOutput>
  postApiRecurringTransactions({
    @Body() DefineRecurringTransactionCommand? body,
  });

  @POST('/api/recurring-transactions/materialize')
  Future<MaterializeRecurringTransactionsCommandOutputDataOutput>
  postApiRecurringTransactionsMaterialize({
    @Body() MaterializeRecurringTransactionsCommand? body,
  });

  @DELETE('/api/recurring-transactions/{id}')
  Future<RecurringTransactionLifecycleCommandOutputDataOutput>
  deleteApiRecurringTransactionsId({@Path('id') required String id});

  @GET('/api/recurring-transactions/{id}')
  Future<RecurringTransactionOutputDataOutput> getApiRecurringTransactionsId({
    @Path('id') required String id,
  });

  @PUT('/api/recurring-transactions/{id}')
  Future<UpdateRecurringTransactionCommandOutputDataOutput>
  putApiRecurringTransactionsId({
    @Path('id') required String id,
    @Body() UpdateRecurringTransactionCommand? body,
  });
}
