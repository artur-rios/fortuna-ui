// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetOutputDataOutput$Response _$BudgetOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return BudgetOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : BudgetOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : BudgetOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : BudgetOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: BudgetOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetOutputDataOutput$ResponseToJson(
  BudgetOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': BudgetOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?BudgetOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
