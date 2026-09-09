// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_status.dart';

part 'import_pdf_invoice_command_output.g.dart';

@JsonSerializable()
class ImportPdfInvoiceCommandOutput {
  const ImportPdfInvoiceCommandOutput({this.importJobId, this.status});

  factory ImportPdfInvoiceCommandOutput.fromJson(Map<String, Object?> json) =>
      _$ImportPdfInvoiceCommandOutputFromJson(json);

  final String? importJobId;
  final ImportJobStatus? status;

  Map<String, Object?> toJson() => _$ImportPdfInvoiceCommandOutputToJson(this);
}
