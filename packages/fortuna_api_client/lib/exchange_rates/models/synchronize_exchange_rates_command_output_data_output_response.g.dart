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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return SynchronizeExchangeRatesCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : SynchronizeExchangeRatesCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SynchronizeExchangeRatesCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SynchronizeExchangeRatesCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        SynchronizeExchangeRatesCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SynchronizeExchangeRatesCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?SynchronizeExchangeRatesCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
