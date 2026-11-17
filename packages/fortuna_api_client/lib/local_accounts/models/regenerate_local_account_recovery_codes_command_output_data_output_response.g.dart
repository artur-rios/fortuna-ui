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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
