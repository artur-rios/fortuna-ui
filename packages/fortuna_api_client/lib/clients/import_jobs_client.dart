// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/import_job_output_data_output.dart';
import '../models/import_job_output_paginated_output.dart';
import '../models/import_job_status.dart';
import '../models/imported_record_output_paginated_output.dart';
import '../models/retry_import_job_command_output_data_output.dart';
import '../models/transaction_source_type.dart';

part 'import_jobs_client.g.dart';

@RestApi()
abstract class ImportJobsClient {
  factory ImportJobsClient(Dio dio, {String? baseUrl}) = _ImportJobsClient;

  @GET('/api/import-jobs')
  Future<ImportJobOutputPaginatedOutput> getApiImportJobs({
    @Query('SourceType') TransactionSourceType? sourceType,
    @Query('Status') ImportJobStatus? status,
    @Query('SortBy') String? sortBy,
    @Query('Descending') bool? descending,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @GET('/api/import-jobs/{id}')
  Future<ImportJobOutputDataOutput> getApiImportJobsId({
    @Path('id') required String id,
  });

  @GET('/api/import-jobs/{id}/records')
  Future<ImportedRecordOutputPaginatedOutput> getApiImportJobsIdRecords({
    @Path('id') required String id,
    @Query('ImportJobId') String? importJobId,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/import-jobs/{id}/retry')
  Future<RetryImportJobCommandOutputDataOutput> postApiImportJobsIdRetry({
    @Path('id') required String id,
  });
}
