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
    disallowNullValues: const ['timestamp'],
  );
  return RequestPersonalDataExportCommandOutputDataOutput$Request(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RequestPersonalDataExportCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
