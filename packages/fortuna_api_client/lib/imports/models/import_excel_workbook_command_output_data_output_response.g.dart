// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_excel_workbook_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportExcelWorkbookCommandOutputDataOutput$Response
_$ImportExcelWorkbookCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ImportExcelWorkbookCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ImportExcelWorkbookCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ImportExcelWorkbookCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ImportExcelWorkbookCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        ImportExcelWorkbookCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ImportExcelWorkbookCommandOutputDataOutput$ResponseToJson(
  ImportExcelWorkbookCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ImportExcelWorkbookCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        ImportExcelWorkbookCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ImportExcelWorkbookCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
