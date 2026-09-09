// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/record_transfer_command.dart';
import '../models/record_transfer_command_output_data_output.dart';
import '../models/transfer_lifecycle_command_output_data_output.dart';
import '../models/transfer_output_data_output.dart';

part 'transfers_client.g.dart';

@RestApi()
abstract class TransfersClient {
  factory TransfersClient(Dio dio, {String? baseUrl}) = _TransfersClient;

  @POST('/api/transfers')
  Future<RecordTransferCommandOutputDataOutput> postApiTransfers({
    @Body() RecordTransferCommand? body,
  });

  @DELETE('/api/transfers/{id}')
  Future<TransferLifecycleCommandOutputDataOutput> deleteApiTransfersId({
    @Path('id') required String id,
  });

  @GET('/api/transfers/{id}')
  Future<TransferOutputDataOutput> getApiTransfersId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/transfers/{id}/restore')
  Future<TransferLifecycleCommandOutputDataOutput> postApiTransfersIdRestore({
    @Path('id') required String id,
  });
}
