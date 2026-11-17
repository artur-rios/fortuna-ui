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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecordInvestmentMovementCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RecordInvestmentMovementCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
