// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanOutputDataOutput$Request
_$InstallmentPlanOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return InstallmentPlanOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InstallmentPlanOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : InstallmentPlanOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : InstallmentPlanOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: InstallmentPlanOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$InstallmentPlanOutputDataOutput$RequestToJson(
  InstallmentPlanOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': InstallmentPlanOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': InstallmentPlanOutputDataOutput$Request._write_messages($value),
  'timestamp': ?InstallmentPlanOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
