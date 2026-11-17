// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutputDataOutput$Response
_$CounterpartyListOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CounterpartyListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CounterpartyListOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: CounterpartyListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutputDataOutput$ResponseToJson(
  CounterpartyListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CounterpartyListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
