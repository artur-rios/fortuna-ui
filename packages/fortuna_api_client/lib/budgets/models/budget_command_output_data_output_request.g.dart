// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCommandOutputDataOutput$Request
_$BudgetCommandOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return BudgetCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : BudgetCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : BudgetCommandOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: BudgetCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetCommandOutputDataOutput$RequestToJson(
  BudgetCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetCommandOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetCommandOutputDataOutput$Request._write_messages($value),
  'timestamp': ?BudgetCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
