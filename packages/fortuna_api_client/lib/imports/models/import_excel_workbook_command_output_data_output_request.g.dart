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
    disallowNullValues: const ['timestamp'],
  );
  return ImportExcelWorkbookCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ImportExcelWorkbookCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ImportExcelWorkbookCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
