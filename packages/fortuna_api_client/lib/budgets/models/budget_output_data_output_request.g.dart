// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetOutputDataOutput$Request _$BudgetOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return BudgetOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : BudgetOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : BudgetOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: BudgetOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetOutputDataOutput$RequestToJson(
  BudgetOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetOutputDataOutput$Request._write_messages($value),
  'timestamp': ?BudgetOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
