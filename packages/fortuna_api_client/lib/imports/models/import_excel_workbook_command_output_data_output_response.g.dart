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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ImportExcelWorkbookCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?ImportExcelWorkbookCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
