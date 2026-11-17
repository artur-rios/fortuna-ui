// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_category_suggestion_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCategorySuggestionOutputDataOutput$Request
_$CounterpartyCategorySuggestionOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CounterpartyCategorySuggestionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyCategorySuggestionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyCategorySuggestionOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyCategorySuggestionOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        CounterpartyCategorySuggestionOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CounterpartyCategorySuggestionOutputDataOutput$RequestToJson(
  CounterpartyCategorySuggestionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        CounterpartyCategorySuggestionOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        CounterpartyCategorySuggestionOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CounterpartyCategorySuggestionOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
