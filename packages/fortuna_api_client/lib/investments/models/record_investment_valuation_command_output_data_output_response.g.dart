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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecordInvestmentValuationCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RecordInvestmentValuationCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
