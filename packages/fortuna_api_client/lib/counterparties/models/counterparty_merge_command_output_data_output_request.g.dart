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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CounterpartyMergeCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyMergeCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyMergeCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyMergeCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CounterpartyMergeCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyMergeCommandOutputDataOutput$RequestToJson(
  CounterpartyMergeCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CounterpartyMergeCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CounterpartyMergeCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CounterpartyMergeCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
