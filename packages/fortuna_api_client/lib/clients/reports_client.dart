// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/net_position_output_data_output.dart';
import '../models/query_records_as_table_query.dart';
import '../models/table_report_output_data_output.dart';
import '../models/transaction_aggregation_output_data_output.dart';
import '../models/transaction_direction.dart';
import '../models/transaction_drill_down_output_data_output.dart';

part 'reports_client.g.dart';

@RestApi()
abstract class ReportsClient {
  factory ReportsClient(Dio dio, {String? baseUrl}) = _ReportsClient;

  @GET('/api/reports/aggregate')
  Future<TransactionAggregationOutputDataOutput> getApiReportsAggregate({
    @Query('Dimension') String? dimension,
    @Query('Granularity') String? granularity,
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
    @Query('RollupCategories') bool? rollupCategories,
    @Query('FinancialAccountId') String? financialAccountId,
    @Query('CreditCardId') String? creditCardId,
    @Query('CategoryId') String? categoryId,
    @Query('TagId') String? tagId,
    @Query('CounterpartyId') String? counterpartyId,
    @Query('Direction') TransactionDirection? direction,
    @Query('MinimumAmount') String? minimumAmount,
    @Query('MaximumAmount') String? maximumAmount,
    @Query('Text') String? text,
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @GET('/api/reports/drill-down')
  Future<TransactionDrillDownOutputDataOutput> getApiReportsDrillDown({
    @Query('Key') String? key,
    @Query('Dimension') String? dimension,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @GET('/api/reports/net-position')
  Future<NetPositionOutputDataOutput> getApiReportsNetPosition({
    @Query('DisplayCurrencyCode') String? displayCurrencyCode,
    @Query('AsOf') DateTime? asOf,
    @Query('PageNumber') int? pageNumber,
    @Query('PageSize') int? pageSize,
  });

  @POST('/api/reports/table')
  Future<TableReportOutputDataOutput> postApiReportsTable({
    @Body() QueryRecordsAsTableQuery? body,
  });
}
