// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_local_account_recovery_codes_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response
_$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutput.fromJson(
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
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$ResponseToJson(
  RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
