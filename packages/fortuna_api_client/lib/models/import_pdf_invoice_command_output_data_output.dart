// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_pdf_invoice_command_output.dart';

part 'import_pdf_invoice_command_output_data_output.g.dart';

@JsonSerializable()
class ImportPdfInvoiceCommandOutputDataOutput {
  const ImportPdfInvoiceCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ImportPdfInvoiceCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ImportPdfInvoiceCommandOutputDataOutputFromJson(json);

  final ImportPdfInvoiceCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ImportPdfInvoiceCommandOutputDataOutputToJson(this);
}
