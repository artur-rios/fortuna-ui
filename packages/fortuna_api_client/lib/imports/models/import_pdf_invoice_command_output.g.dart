// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_pdf_invoice_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportPdfInvoiceCommandOutput _$ImportPdfInvoiceCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['importJobId', 'status'],
    disallowNullValues: const ['importJobId', 'status'],
  );
  return ImportPdfInvoiceCommandOutput(
    importJobId: json['importJobId'] as String?,
    status: ImportPdfInvoiceCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$ImportPdfInvoiceCommandOutputToJson(
  ImportPdfInvoiceCommandOutput instance,
) => <String, dynamic>{
  'importJobId': ?instance.importJobId,
  'status': ?ImportPdfInvoiceCommandOutput._write_status(instance.status),
};
