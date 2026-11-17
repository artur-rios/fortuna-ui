// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_data_export_query_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveDataExportQueryOutputDataOutput$Response
_$RetrieveDataExportQueryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RetrieveDataExportQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RetrieveDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: RetrieveDataExportQueryOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RetrieveDataExportQueryOutputDataOutput$ResponseToJson(
  RetrieveDataExportQueryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RetrieveDataExportQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
