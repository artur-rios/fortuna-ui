// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_personal_data_export_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPersonalDataExportCommandOutputDataOutput$Request
_$RequestPersonalDataExportCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RequestPersonalDataExportCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RequestPersonalDataExportCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RequestPersonalDataExportCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RequestPersonalDataExportCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RequestPersonalDataExportCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RequestPersonalDataExportCommandOutputDataOutput$RequestToJson(
  RequestPersonalDataExportCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RequestPersonalDataExportCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RequestPersonalDataExportCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RequestPersonalDataExportCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
