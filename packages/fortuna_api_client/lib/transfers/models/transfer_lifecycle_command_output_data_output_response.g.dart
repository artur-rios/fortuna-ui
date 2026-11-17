// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_lifecycle_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferLifecycleCommandOutputDataOutput$Response
_$TransferLifecycleCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return TransferLifecycleCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransferLifecycleCommandOutput.fromJson(
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
        TransferLifecycleCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$TransferLifecycleCommandOutputDataOutput$ResponseToJson(
  TransferLifecycleCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?TransferLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
