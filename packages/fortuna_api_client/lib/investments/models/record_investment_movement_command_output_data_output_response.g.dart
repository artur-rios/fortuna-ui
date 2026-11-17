// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommandOutputDataOutput$Response
_$RecordInvestmentMovementCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecordInvestmentMovementCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecordInvestmentMovementCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordInvestmentMovementCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordInvestmentMovementCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecordInvestmentMovementCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInvestmentMovementCommandOutputDataOutput$ResponseToJson(
  RecordInvestmentMovementCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordInvestmentMovementCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordInvestmentMovementCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecordInvestmentMovementCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
