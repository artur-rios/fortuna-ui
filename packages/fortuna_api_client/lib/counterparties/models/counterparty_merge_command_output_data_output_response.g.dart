// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_merge_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyMergeCommandOutputDataOutput$Response
_$CounterpartyMergeCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CounterpartyMergeCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CounterpartyMergeCommandOutput.fromJson(
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
        CounterpartyMergeCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$CounterpartyMergeCommandOutputDataOutput$ResponseToJson(
  CounterpartyMergeCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?CounterpartyMergeCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
