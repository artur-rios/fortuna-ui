// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanOutputDataOutput$Response
_$InstallmentPlanOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return InstallmentPlanOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : InstallmentPlanOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : InstallmentPlanOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : InstallmentPlanOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: InstallmentPlanOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$InstallmentPlanOutputDataOutput$ResponseToJson(
  InstallmentPlanOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': InstallmentPlanOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': InstallmentPlanOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?InstallmentPlanOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
