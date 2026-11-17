// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommandOutputDataOutput$Response
_$RecordManualExchangeRateCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecordManualExchangeRateCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecordManualExchangeRateCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordManualExchangeRateCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordManualExchangeRateCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecordManualExchangeRateCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordManualExchangeRateCommandOutputDataOutput$ResponseToJson(
  RecordManualExchangeRateCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordManualExchangeRateCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordManualExchangeRateCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecordManualExchangeRateCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
