// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_merge_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyMergeCommandOutputDataOutput$Request
_$CounterpartyMergeCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CounterpartyMergeCommandOutputDataOutput$Request(
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
    timestamp: CounterpartyMergeCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyMergeCommandOutputDataOutput$RequestToJson(
  CounterpartyMergeCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CounterpartyMergeCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
