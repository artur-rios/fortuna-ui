// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_local_account_recovery_codes_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request
_$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$RequestToJson(
  RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
