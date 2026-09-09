// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/counterparty_category_suggestion_output_data_output.dart';
import '../models/counterparty_command_output_data_output.dart';
import '../models/counterparty_list_output_data_output.dart';
import '../models/counterparty_merge_command_output_data_output.dart';
import '../models/create_counterparty_command.dart';
import '../models/merge_counterparties_command.dart';
import '../models/update_counterparty_command.dart';

part 'counterparties_client.g.dart';

@RestApi()
abstract class CounterpartiesClient {
  factory CounterpartiesClient(Dio dio, {String? baseUrl}) =
      _CounterpartiesClient;

  @GET('/api/counterparties')
  Future<CounterpartyListOutputDataOutput> getApiCounterparties({
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/counterparties')
  Future<CounterpartyCommandOutputDataOutput> postApiCounterparties({
    @Body() CreateCounterpartyCommand? body,
  });

  @DELETE('/api/counterparties/{id}')
  Future<CounterpartyCommandOutputDataOutput> deleteApiCounterpartiesId({
    @Path('id') required String id,
  });

  @PUT('/api/counterparties/{id}')
  Future<CounterpartyCommandOutputDataOutput> putApiCounterpartiesId({
    @Path('id') required String id,
    @Body() UpdateCounterpartyCommand? body,
  });

  @POST('/api/counterparties/{id}/merge')
  Future<CounterpartyMergeCommandOutputDataOutput>
  postApiCounterpartiesIdMerge({
    @Path('id') required String id,
    @Body() MergeCounterpartiesCommand? body,
  });

  @GET('/api/counterparties/{id}/suggested-category')
  Future<CounterpartyCategorySuggestionOutputDataOutput>
  getApiCounterpartiesIdSuggestedCategory({@Path('id') required String id});
}
