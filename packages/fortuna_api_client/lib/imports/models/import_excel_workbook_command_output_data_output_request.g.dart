// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_excel_workbook_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportExcelWorkbookCommandOutputDataOutput$Request
_$ImportExcelWorkbookCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ImportExcelWorkbookCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ImportExcelWorkbookCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ImportExcelWorkbookCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ImportExcelWorkbookCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        ImportExcelWorkbookCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$ImportExcelWorkbookCommandOutputDataOutput$RequestToJson(
  ImportExcelWorkbookCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ImportExcelWorkbookCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        ImportExcelWorkbookCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ImportExcelWorkbookCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
