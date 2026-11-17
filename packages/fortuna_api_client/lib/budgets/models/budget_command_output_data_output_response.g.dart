// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetCommandOutputDataOutput$Response
_$BudgetCommandOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return BudgetCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : BudgetCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : BudgetCommandOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: BudgetCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetCommandOutputDataOutput$ResponseToJson(
  BudgetCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetCommandOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetCommandOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?BudgetCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
