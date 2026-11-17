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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ListSupportedCurrenciesQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ListSupportedCurrenciesQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ListSupportedCurrenciesQueryOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ListSupportedCurrenciesQueryOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        ListSupportedCurrenciesQueryOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ListSupportedCurrenciesQueryOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ListSupportedCurrenciesQueryOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
