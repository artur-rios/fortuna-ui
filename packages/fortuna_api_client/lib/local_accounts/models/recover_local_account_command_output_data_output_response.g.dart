// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutputDataOutput$Response
_$RecoverLocalAccountCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecoverLocalAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecoverLocalAccountCommandOutput.fromJson(
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
        RecoverLocalAccountCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecoverLocalAccountCommandOutputDataOutput$ResponseToJson(
  RecoverLocalAccountCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RecoverLocalAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
