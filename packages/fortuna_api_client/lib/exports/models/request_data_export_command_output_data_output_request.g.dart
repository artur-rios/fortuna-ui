// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_data_export_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDataExportCommandOutputDataOutput$Request
_$RequestDataExportCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RequestDataExportCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RequestDataExportCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RequestDataExportCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RequestDataExportCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: RequestDataExportCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$RequestDataExportCommandOutputDataOutput$RequestToJson(
  RequestDataExportCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RequestDataExportCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RequestDataExportCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RequestDataExportCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
