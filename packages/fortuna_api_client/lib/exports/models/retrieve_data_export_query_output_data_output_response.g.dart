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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RetrieveDataExportQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RetrieveDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RetrieveDataExportQueryOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RetrieveDataExportQueryOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors': RetrieveDataExportQueryOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RetrieveDataExportQueryOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RetrieveDataExportQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
