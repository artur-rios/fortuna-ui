// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/synchronize_connection_command.dart';
import '../models/synchronize_connection_command_output_data_output.dart';

part 'connection_synchronization_client.g.dart';

@RestApi()
abstract class ConnectionSynchronizationClient {
  factory ConnectionSynchronizationClient(Dio dio, {String? baseUrl}) =
      _ConnectionSynchronizationClient;

  @POST('/api/connections/{id}/sync')
  Future<SynchronizeConnectionCommandOutputDataOutput>
  postApiConnectionsIdSync({
    @Path('id') required String id,
    @Body() SynchronizeConnectionCommand? body,
  });
}
