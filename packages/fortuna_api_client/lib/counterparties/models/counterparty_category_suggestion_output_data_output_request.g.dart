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
    disallowNullValues: const ['timestamp'],
  );
  return CounterpartyCategorySuggestionOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CounterpartyCategorySuggestionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CounterpartyCategorySuggestionOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
