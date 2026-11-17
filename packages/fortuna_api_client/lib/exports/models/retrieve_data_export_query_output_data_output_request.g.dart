// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrieve_data_export_query_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveDataExportQueryOutputDataOutput$Request
_$RetrieveDataExportQueryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RetrieveDataExportQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RetrieveDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RetrieveDataExportQueryOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RetrieveDataExportQueryOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RetrieveDataExportQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RetrieveDataExportQueryOutputDataOutput$RequestToJson(
  RetrieveDataExportQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RetrieveDataExportQueryOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': RetrieveDataExportQueryOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?RetrieveDataExportQueryOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
