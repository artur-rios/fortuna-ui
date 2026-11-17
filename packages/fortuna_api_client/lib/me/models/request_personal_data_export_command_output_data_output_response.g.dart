// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_personal_data_export_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPersonalDataExportCommandOutputDataOutput$Response
_$RequestPersonalDataExportCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RequestPersonalDataExportCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RequestPersonalDataExportCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RequestPersonalDataExportCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RequestPersonalDataExportCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RequestPersonalDataExportCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RequestPersonalDataExportCommandOutputDataOutput$ResponseToJson(
  RequestPersonalDataExportCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RequestPersonalDataExportCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RequestPersonalDataExportCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RequestPersonalDataExportCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
