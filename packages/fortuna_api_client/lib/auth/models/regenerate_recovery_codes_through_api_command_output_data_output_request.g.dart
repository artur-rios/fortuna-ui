// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RegenerateRecoveryCodesThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$RequestToJson(
  RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RegenerateRecoveryCodesThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
