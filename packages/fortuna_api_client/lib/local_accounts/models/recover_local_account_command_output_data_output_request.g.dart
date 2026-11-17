// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutputDataOutput$Request
_$RecoverLocalAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RecoverLocalAccountCommandOutputDataOutput$Request(
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
    timestamp:
        RecoverLocalAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$RecoverLocalAccountCommandOutputDataOutput$RequestToJson(
  RecoverLocalAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecoverLocalAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
