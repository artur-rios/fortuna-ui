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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordInvestmentMovementCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInvestmentMovementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordInvestmentMovementCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordInvestmentMovementCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        RecordInvestmentMovementCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordInvestmentMovementCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecordInvestmentMovementCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
