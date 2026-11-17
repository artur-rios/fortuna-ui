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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return InstallmentPlanLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InstallmentPlanLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : InstallmentPlanLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : InstallmentPlanLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        InstallmentPlanLifecycleCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        InstallmentPlanLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?InstallmentPlanLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
