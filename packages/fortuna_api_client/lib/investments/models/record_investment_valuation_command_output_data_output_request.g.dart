// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommandOutputDataOutput$Request
_$RecordInvestmentValuationCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordInvestmentValuationCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInvestmentValuationCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordInvestmentValuationCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordInvestmentValuationCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RecordInvestmentValuationCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInvestmentValuationCommandOutputDataOutput$RequestToJson(
  RecordInvestmentValuationCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordInvestmentValuationCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordInvestmentValuationCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecordInvestmentValuationCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
