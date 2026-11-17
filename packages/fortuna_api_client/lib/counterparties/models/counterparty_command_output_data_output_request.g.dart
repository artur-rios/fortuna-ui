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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CounterpartyCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CounterpartyCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyCommandOutputDataOutput$RequestToJson(
  CounterpartyCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CounterpartyCommandOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CounterpartyCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?CounterpartyCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
