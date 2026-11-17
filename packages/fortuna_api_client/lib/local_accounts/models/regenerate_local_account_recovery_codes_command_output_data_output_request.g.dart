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
    disallowNullValues: const ['timestamp'],
  );
  return RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
