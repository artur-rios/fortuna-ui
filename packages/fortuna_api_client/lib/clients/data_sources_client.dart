// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/data_source_list_output_data_output.dart';

part 'data_sources_client.g.dart';

@RestApi()
abstract class DataSourcesClient {
  factory DataSourcesClient(Dio dio, {String? baseUrl}) = _DataSourcesClient;

  @GET('/api/data-sources')
  Future<DataSourceListOutputDataOutput> getApiDataSources();
}
