// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/import_excel_workbook_command_output_data_output.dart';
import '../models/import_pdf_invoice_command_output_data_output.dart';
import '../models/import_target_type.dart';

part 'imports_client.g.dart';

@RestApi()
abstract class ImportsClient {
  factory ImportsClient(Dio dio, {String? baseUrl}) = _ImportsClient;

  @MultiPart()
  @POST('/api/imports/excel')
  Future<ImportExcelWorkbookCommandOutputDataOutput> postApiImportsExcel({
    @Part(name: 'AmountColumn') String? amountColumn,
    @Part(name: 'CategoryColumn') String? categoryColumn,
    @Part(name: 'CreateMissingCategories') bool? createMissingCategories,
    @Part(name: 'DateColumn') String? dateColumn,
    @Part(name: 'DescriptionColumn') String? descriptionColumn,
    @Part(name: 'DirectionColumn') String? directionColumn,
    @Part(name: 'ExternalIdColumn') String? externalIdColumn,
    @Part(name: 'File') File? file,
    @Part(name: 'TargetId') String? targetId,
    @Part(name: 'TargetType') ImportTargetType? targetType,
  });

  @MultiPart()
  @POST('/api/imports/pdf')
  Future<ImportPdfInvoiceCommandOutputDataOutput> postApiImportsPdf({
    @Part(name: 'CreditCardId') String? creditCardId,
    @Part(name: 'File') File? file,
  });
}
