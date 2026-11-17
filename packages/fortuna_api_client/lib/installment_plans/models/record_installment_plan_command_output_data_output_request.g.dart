// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommandOutputDataOutput$Request
_$RecordInstallmentPlanCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RecordInstallmentPlanCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInstallmentPlanCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecordInstallmentPlanCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecordInstallmentPlanCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RecordInstallmentPlanCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInstallmentPlanCommandOutputDataOutput$RequestToJson(
  RecordInstallmentPlanCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        RecordInstallmentPlanCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        RecordInstallmentPlanCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RecordInstallmentPlanCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
