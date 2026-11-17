// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutputDataOutput$Response
_$InvestmentOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return InvestmentOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : InvestmentOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : InvestmentOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: InvestmentOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$InvestmentOutputDataOutput$ResponseToJson(
  InvestmentOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': InvestmentOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': InvestmentOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?InvestmentOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
