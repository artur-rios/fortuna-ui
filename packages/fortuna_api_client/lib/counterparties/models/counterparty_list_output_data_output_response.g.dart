// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutputDataOutput$Response
_$CounterpartyListOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CounterpartyListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CounterpartyListOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyListOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyListOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: CounterpartyListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutputDataOutput$ResponseToJson(
  CounterpartyListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CounterpartyListOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CounterpartyListOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?CounterpartyListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
