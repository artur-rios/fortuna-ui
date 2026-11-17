// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportOutputDataOutput$Response
_$TableReportOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return TableReportOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TableReportOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: TableReportOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TableReportOutputDataOutput$ResponseToJson(
  TableReportOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?TableReportOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
