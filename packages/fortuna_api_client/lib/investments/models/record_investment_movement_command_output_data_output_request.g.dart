// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommandOutputDataOutput$Request
_$RecordInvestmentMovementCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return RecordInvestmentMovementCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInvestmentMovementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        RecordInvestmentMovementCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInvestmentMovementCommandOutputDataOutput$RequestToJson(
  RecordInvestmentMovementCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecordInvestmentMovementCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
