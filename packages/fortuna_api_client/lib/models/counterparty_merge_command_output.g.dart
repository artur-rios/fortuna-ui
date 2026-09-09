// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_merge_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyMergeCommandOutput _$CounterpartyMergeCommandOutputFromJson(
  Map<String, dynamic> json,
) => CounterpartyMergeCommandOutput(
  id: json['id'] as String?,
  reassignedTransactionCount: (json['reassignedTransactionCount'] as num?)
      ?.toInt(),
  sourceId: json['sourceId'] as String?,
  targetId: json['targetId'] as String?,
);

Map<String, dynamic> _$CounterpartyMergeCommandOutputToJson(
  CounterpartyMergeCommandOutput instance,
) => <String, dynamic>{
  'id': instance.id,
  'reassignedTransactionCount': instance.reassignedTransactionCount,
  'sourceId': instance.sourceId,
  'targetId': instance.targetId,
};
