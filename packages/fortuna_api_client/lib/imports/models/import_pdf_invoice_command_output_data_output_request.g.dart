// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_pdf_invoice_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportPdfInvoiceCommandOutputDataOutput$Request
_$ImportPdfInvoiceCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ImportPdfInvoiceCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ImportPdfInvoiceCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: ImportPdfInvoiceCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ImportPdfInvoiceCommandOutputDataOutput$RequestToJson(
  ImportPdfInvoiceCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ImportPdfInvoiceCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
