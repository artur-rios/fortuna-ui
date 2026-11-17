// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputDataOutput$Request
_$FinancialAccountOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return FinancialAccountOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : FinancialAccountOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: FinancialAccountOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountOutputDataOutput$RequestToJson(
  FinancialAccountOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': FinancialAccountOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': FinancialAccountOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?FinancialAccountOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
