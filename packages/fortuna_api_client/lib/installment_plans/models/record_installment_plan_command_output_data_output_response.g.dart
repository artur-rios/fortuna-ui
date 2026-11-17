// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommandOutputDataOutput$Response
_$RecordInstallmentPlanCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return RecordInstallmentPlanCommandOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp:
        RecordInstallmentPlanCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecordInstallmentPlanCommandOutputDataOutput$ResponseToJson(
  RecordInstallmentPlanCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?RecordInstallmentPlanCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
