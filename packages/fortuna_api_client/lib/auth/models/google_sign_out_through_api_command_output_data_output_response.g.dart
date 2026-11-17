// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_out_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignOutThroughApiCommandOutputDataOutput$Response
_$GoogleSignOutThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return GoogleSignOutThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoogleSignOutThroughApiCommandOutput.fromJson(
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
        GoogleSignOutThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignOutThroughApiCommandOutputDataOutput$ResponseToJson(
  GoogleSignOutThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?GoogleSignOutThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
