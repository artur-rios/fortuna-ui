// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanLifecycleCommandOutputDataOutput$Request
_$InstallmentPlanLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return InstallmentPlanLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InstallmentPlanLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        InstallmentPlanLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$InstallmentPlanLifecycleCommandOutputDataOutput$RequestToJson(
  InstallmentPlanLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?InstallmentPlanLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
