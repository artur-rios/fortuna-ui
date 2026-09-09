// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/audit_entry_output_paginated_output.dart';
import '../models/audit_outcome.dart';

part 'audit_entries_client.g.dart';

@RestApi()
abstract class AuditEntriesClient {
  factory AuditEntriesClient(Dio dio, {String? baseUrl}) = _AuditEntriesClient;

  @GET('/api/audit-entries')
  Future<AuditEntryOutputPaginatedOutput> getApiAuditEntries({
    @Query('EntityType') String? entityType,
    @Query('EntityId') String? entityId,
    @Query('Operation') String? operation,
    @Query('Outcome') AuditOutcome? outcome,
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });
}
