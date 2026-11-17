// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCommandOutputDataOutput$Request
_$CounterpartyCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CounterpartyCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CounterpartyCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyCommandOutputDataOutput$RequestToJson(
  CounterpartyCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CounterpartyCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
