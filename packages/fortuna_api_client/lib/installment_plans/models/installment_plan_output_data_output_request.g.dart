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
    disallowNullValues: const ['timestamp'],
  );
  return InstallmentPlanOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InstallmentPlanOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: InstallmentPlanOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$InstallmentPlanOutputDataOutput$RequestToJson(
  InstallmentPlanOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?InstallmentPlanOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
