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
    disallowNullValues: const ['timestamp'],
  );
  return RecordInvestmentValuationCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInvestmentValuationCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecordInvestmentValuationCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
