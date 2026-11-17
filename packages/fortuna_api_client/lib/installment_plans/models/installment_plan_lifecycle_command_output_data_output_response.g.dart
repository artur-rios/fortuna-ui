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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return InstallmentPlanLifecycleCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : InstallmentPlanLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : InstallmentPlanLifecycleCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : InstallmentPlanLifecycleCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        InstallmentPlanLifecycleCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        InstallmentPlanLifecycleCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?InstallmentPlanLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
