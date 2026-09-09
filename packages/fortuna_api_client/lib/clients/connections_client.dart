// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/connection_output_data_output.dart';
import '../models/connection_output_paginated_output.dart';
import '../models/connection_status.dart';
import '../models/create_connection_command.dart';
import '../models/create_connection_command_output_data_output.dart';
import '../models/reauthenticate_connection_command.dart';
import '../models/reauthenticate_connection_command_output_data_output.dart';
import '../models/revoke_connection_command_output_data_output.dart';
import '../models/transaction_source_type.dart';

part 'connections_client.g.dart';

@RestApi()
abstract class ConnectionsClient {
  factory ConnectionsClient(Dio dio, {String? baseUrl}) = _ConnectionsClient;

  @GET('/api/connections')
  Future<ConnectionOutputPaginatedOutput> getApiConnections({
    @Query('DataSourceType') TransactionSourceType? dataSourceType,
    @Query('Status') ConnectionStatus? status,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/connections')
  Future<CreateConnectionCommandOutputDataOutput> postApiConnections({
    @Body() CreateConnectionCommand? body,
  });

  @GET('/api/connections/{id}')
  Future<ConnectionOutputDataOutput> getApiConnectionsId({
    @Path('id') required String id,
  });

  @POST('/api/connections/{id}/reauthenticate')
  Future<ReauthenticateConnectionCommandOutputDataOutput>
  postApiConnectionsIdReauthenticate({
    @Path('id') required String id,
    @Body() ReauthenticateConnectionCommand? body,
  });

  @POST('/api/connections/{id}/revoke')
  Future<RevokeConnectionCommandOutputDataOutput> postApiConnectionsIdRevoke({
    @Path('id') required String id,
  });
}
