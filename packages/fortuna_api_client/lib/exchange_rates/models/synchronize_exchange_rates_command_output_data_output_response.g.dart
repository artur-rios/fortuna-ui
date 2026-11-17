// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_exchange_rates_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeExchangeRatesCommandOutputDataOutput$Response
_$SynchronizeExchangeRatesCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return SynchronizeExchangeRatesCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : SynchronizeExchangeRatesCommandOutput.fromJson(
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
        SynchronizeExchangeRatesCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SynchronizeExchangeRatesCommandOutputDataOutput$ResponseToJson(
  SynchronizeExchangeRatesCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?SynchronizeExchangeRatesCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
