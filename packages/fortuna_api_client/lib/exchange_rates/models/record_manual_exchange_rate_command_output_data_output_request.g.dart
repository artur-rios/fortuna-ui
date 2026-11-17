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
    disallowNullValues: const ['timestamp'],
  );
  return RecordManualExchangeRateCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordManualExchangeRateCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecordManualExchangeRateCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
