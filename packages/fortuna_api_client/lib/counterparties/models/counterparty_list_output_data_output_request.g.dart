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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CounterpartyListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyListOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyListOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyListOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CounterpartyListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutputDataOutput$RequestToJson(
  CounterpartyListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CounterpartyListOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CounterpartyListOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?CounterpartyListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
