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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CounterpartyCategorySuggestionOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?CounterpartyCategorySuggestionOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
