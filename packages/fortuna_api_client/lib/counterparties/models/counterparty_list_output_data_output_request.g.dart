// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutputDataOutput$Request
_$CounterpartyListOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CounterpartyListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyListOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CounterpartyListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutputDataOutput$RequestToJson(
  CounterpartyListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CounterpartyListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
