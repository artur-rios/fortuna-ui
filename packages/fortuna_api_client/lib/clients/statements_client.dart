// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/close_credit_card_statement_command_output_data_output.dart';
import '../models/credit_card_statement_output_data_output.dart';
import '../models/settle_credit_card_statement_command.dart';
import '../models/settle_credit_card_statement_command_output_data_output.dart';

part 'statements_client.g.dart';

@RestApi()
abstract class StatementsClient {
  factory StatementsClient(Dio dio, {String? baseUrl}) = _StatementsClient;

  @GET('/api/statements/{id}')
  Future<CreditCardStatementOutputDataOutput> getApiStatementsId({
    @Path('id') required String id,
  });

  @POST('/api/statements/{id}/close')
  Future<CloseCreditCardStatementCommandOutputDataOutput>
  postApiStatementsIdClose({@Path('id') required String id});

  @POST('/api/statements/{id}/settle')
  Future<SettleCreditCardStatementCommandOutputDataOutput>
  postApiStatementsIdSettle({
    @Path('id') required String id,
    @Body() SettleCreditCardStatementCommand? body,
  });
}
