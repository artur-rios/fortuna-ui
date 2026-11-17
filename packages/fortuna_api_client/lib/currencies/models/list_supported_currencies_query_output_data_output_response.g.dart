// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_supported_currencies_query_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSupportedCurrenciesQueryOutputDataOutput$Response
_$ListSupportedCurrenciesQueryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ListSupportedCurrenciesQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ListSupportedCurrenciesQueryOutput.fromJson(
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
        ListSupportedCurrenciesQueryOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ListSupportedCurrenciesQueryOutputDataOutput$ResponseToJson(
  ListSupportedCurrenciesQueryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?ListSupportedCurrenciesQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
