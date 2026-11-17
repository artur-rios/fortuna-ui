// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_supported_currencies_query_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSupportedCurrenciesQueryOutputDataOutput$Request
_$ListSupportedCurrenciesQueryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ListSupportedCurrenciesQueryOutputDataOutput$Request(
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
    timestamp:
        ListSupportedCurrenciesQueryOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ListSupportedCurrenciesQueryOutputDataOutput$RequestToJson(
  ListSupportedCurrenciesQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ListSupportedCurrenciesQueryOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
