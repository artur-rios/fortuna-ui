// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputDataOutput$Response
_$CreditCardOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CreditCardOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreditCardOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: CreditCardOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreditCardOutputDataOutput$ResponseToJson(
  CreditCardOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CreditCardOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
