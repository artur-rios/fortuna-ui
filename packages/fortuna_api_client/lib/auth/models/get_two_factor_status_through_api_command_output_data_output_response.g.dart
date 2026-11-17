// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_two_factor_status_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTwoFactorStatusThroughApiCommandOutputDataOutput$Response
_$GetTwoFactorStatusThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return GetTwoFactorStatusThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GetTwoFactorStatusThroughApiCommandOutput.fromJson(
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
        GetTwoFactorStatusThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GetTwoFactorStatusThroughApiCommandOutputDataOutput$ResponseToJson(
  GetTwoFactorStatusThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?GetTwoFactorStatusThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
