// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommandOutputDataOutput$Response
_$RecordInvestmentValuationCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecordInvestmentValuationCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecordInvestmentValuationCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordInvestmentValuationCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordInvestmentValuationCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecordInvestmentValuationCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInvestmentValuationCommandOutputDataOutput$ResponseToJson(
  RecordInvestmentValuationCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordInvestmentValuationCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordInvestmentValuationCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecordInvestmentValuationCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
