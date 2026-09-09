// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_lifecycle_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLifecycleCommandOutput _$CategoryLifecycleCommandOutputFromJson(
  Map<String, dynamic> json,
) => CategoryLifecycleCommandOutput(
  id: json['id'] as String?,
  liveTransactionCount: (json['liveTransactionCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$CategoryLifecycleCommandOutputToJson(
  CategoryLifecycleCommandOutput instance,
) => <String, dynamic>{
  'id': instance.id,
  'liveTransactionCount': instance.liveTransactionCount,
};
