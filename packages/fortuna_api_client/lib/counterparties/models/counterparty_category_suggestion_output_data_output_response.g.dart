// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_category_suggestion_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCategorySuggestionOutputDataOutput$Response
_$CounterpartyCategorySuggestionOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CounterpartyCategorySuggestionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CounterpartyCategorySuggestionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CounterpartyCategorySuggestionOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CounterpartyCategorySuggestionOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        CounterpartyCategorySuggestionOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CounterpartyCategorySuggestionOutputDataOutput$ResponseToJson(
  CounterpartyCategorySuggestionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        CounterpartyCategorySuggestionOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        CounterpartyCategorySuggestionOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?CounterpartyCategorySuggestionOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
