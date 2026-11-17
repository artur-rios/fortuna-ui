// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyOutputDataOutput$Response _$CurrencyOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CurrencyOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CurrencyOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : CurrencyOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CurrencyOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: CurrencyOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CurrencyOutputDataOutput$ResponseToJson(
  CurrencyOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CurrencyOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CurrencyOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?CurrencyOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
