// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetListOutputDataOutput$Request _$BudgetListOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return BudgetListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : BudgetListOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : BudgetListOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetListOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: BudgetListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetListOutputDataOutput$RequestToJson(
  BudgetListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetListOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetListOutputDataOutput$Request._write_messages($value),
  'timestamp': ?BudgetListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
