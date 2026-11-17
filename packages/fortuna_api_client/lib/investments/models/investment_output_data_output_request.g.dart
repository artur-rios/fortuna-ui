// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutputDataOutput$Request _$InvestmentOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return InvestmentOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InvestmentOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : InvestmentOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: InvestmentOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$InvestmentOutputDataOutput$RequestToJson(
  InvestmentOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': InvestmentOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': InvestmentOutputDataOutput$Request._write_messages($value),
  'timestamp': ?InvestmentOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
