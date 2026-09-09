// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/operational_health_output.dart';

part 'detailed_health_check_client.g.dart';

@RestApi()
abstract class DetailedHealthCheckClient {
  factory DetailedHealthCheckClient(Dio dio, {String? baseUrl}) =
      _DetailedHealthCheckClient;

  @GET('/healthcheck/detailed')
  Future<OperationalHealthOutput> getHealthcheckDetailed();
}
