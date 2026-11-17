// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetListOutputDataOutput$Response
_$BudgetListOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return BudgetListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : BudgetListOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : BudgetListOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetListOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: BudgetListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetListOutputDataOutput$ResponseToJson(
  BudgetListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetListOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetListOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?BudgetListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
