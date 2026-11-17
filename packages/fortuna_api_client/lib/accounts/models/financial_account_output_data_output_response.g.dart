// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputDataOutput$Response
_$FinancialAccountOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return FinancialAccountOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : FinancialAccountOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: FinancialAccountOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountOutputDataOutput$ResponseToJson(
  FinancialAccountOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': FinancialAccountOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': FinancialAccountOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?FinancialAccountOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
