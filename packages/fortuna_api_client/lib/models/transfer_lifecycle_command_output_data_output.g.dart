// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_lifecycle_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferLifecycleCommandOutputDataOutput
_$TransferLifecycleCommandOutputDataOutputFromJson(Map<String, dynamic> json) =>
    TransferLifecycleCommandOutputDataOutput(
      data: json['data'] == null
          ? null
          : TransferLifecycleCommandOutput.fromJson(
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

Map<String, dynamic> _$TransferLifecycleCommandOutputDataOutputToJson(
  TransferLifecycleCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
