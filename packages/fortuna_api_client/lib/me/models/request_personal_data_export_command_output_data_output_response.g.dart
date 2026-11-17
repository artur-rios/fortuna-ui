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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RequestPersonalDataExportCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RequestPersonalDataExportCommandOutput.fromJson(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RequestPersonalDataExportCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
