// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommandOutputDataOutput$Request
_$RecordManualExchangeRateCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordManualExchangeRateCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordManualExchangeRateCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordManualExchangeRateCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordManualExchangeRateCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RecordManualExchangeRateCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordManualExchangeRateCommandOutputDataOutput$RequestToJson(
  RecordManualExchangeRateCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordManualExchangeRateCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordManualExchangeRateCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecordManualExchangeRateCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
