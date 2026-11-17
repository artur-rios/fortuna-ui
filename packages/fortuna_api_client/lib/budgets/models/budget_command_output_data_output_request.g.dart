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
    disallowNullValues: const ['timestamp'],
  );
  return BudgetCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : BudgetCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: BudgetCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetCommandOutputDataOutput$RequestToJson(
  BudgetCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?BudgetCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
