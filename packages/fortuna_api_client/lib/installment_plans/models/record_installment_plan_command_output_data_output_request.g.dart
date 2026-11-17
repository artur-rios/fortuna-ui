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
    disallowNullValues: const ['timestamp'],
  );
  return RecordInstallmentPlanCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RecordInstallmentPlanCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?RecordInstallmentPlanCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
