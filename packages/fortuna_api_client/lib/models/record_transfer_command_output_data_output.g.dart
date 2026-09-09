// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommandOutputDataOutput
_$RecordTransferCommandOutputDataOutputFromJson(Map<String, dynamic> json) =>
    RecordTransferCommandOutputDataOutput(
      data: json['data'] == null
          ? null
          : RecordTransferCommandOutput.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      success: json['success'] as bool?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$RecordTransferCommandOutputDataOutputToJson(
  RecordTransferCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
