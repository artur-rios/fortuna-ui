// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_exchange_rates_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeExchangeRatesCommandOutputDataOutput$Request
_$SynchronizeExchangeRatesCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return SynchronizeExchangeRatesCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : SynchronizeExchangeRatesCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SynchronizeExchangeRatesCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SynchronizeExchangeRatesCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        SynchronizeExchangeRatesCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SynchronizeExchangeRatesCommandOutputDataOutput$RequestToJson(
  SynchronizeExchangeRatesCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        SynchronizeExchangeRatesCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SynchronizeExchangeRatesCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?SynchronizeExchangeRatesCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
