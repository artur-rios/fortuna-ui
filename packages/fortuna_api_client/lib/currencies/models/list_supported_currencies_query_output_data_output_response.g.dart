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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ListSupportedCurrenciesQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ListSupportedCurrenciesQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ListSupportedCurrenciesQueryOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ListSupportedCurrenciesQueryOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        ListSupportedCurrenciesQueryOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ListSupportedCurrenciesQueryOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ListSupportedCurrenciesQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
