// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/request_data_export_command.dart';
import '../models/retrieve_data_export_query_output_data_output.dart';

part 'exports_client.g.dart';

@RestApi()
abstract class ExportsClient {
  factory ExportsClient(Dio dio, {String? baseUrl}) = _ExportsClient;

  @POST('/api/exports')
  @DioResponseType(ResponseType.stream)
  Stream<String> postApiExports({@Body() RequestDataExportCommand? body});

  @GET('/api/exports/{id}')
  Future<RetrieveDataExportQueryOutputDataOutput> getApiExportsId({
    @Path('id') required String id,
  });
}
