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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TableReportOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TableReportOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TableReportOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TableReportOutputDataOutput$Response._read_messages(json['messages']),
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
  if (instance.errors case final $value?)
    'errors': TableReportOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TableReportOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?TableReportOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
