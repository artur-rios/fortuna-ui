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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ImportPdfInvoiceCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ImportPdfInvoiceCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ImportPdfInvoiceCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ImportPdfInvoiceCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: ImportPdfInvoiceCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ImportPdfInvoiceCommandOutputDataOutput$RequestToJson(
  ImportPdfInvoiceCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ImportPdfInvoiceCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': ImportPdfInvoiceCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?ImportPdfInvoiceCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
