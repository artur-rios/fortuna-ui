// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_lifecycle_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanLifecycleCommandOutputDataOutput$Response
_$InstallmentPlanLifecycleCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return InstallmentPlanLifecycleCommandOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp:
        InstallmentPlanLifecycleCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$InstallmentPlanLifecycleCommandOutputDataOutput$ResponseToJson(
  InstallmentPlanLifecycleCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?InstallmentPlanLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
