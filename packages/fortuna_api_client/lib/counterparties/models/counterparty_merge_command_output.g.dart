// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_merge_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyMergeCommandOutput _$CounterpartyMergeCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'id',
      'reassignedTransactionCount',
      'sourceId',
      'targetId',
    ],
    disallowNullValues: const [
      'id',
      'reassignedTransactionCount',
      'sourceId',
      'targetId',
    ],
  );
  return CounterpartyMergeCommandOutput(
    id: json['id'] as String?,
    reassignedTransactionCount:
        CounterpartyMergeCommandOutput._read_reassignedTransactionCount(
          json['reassignedTransactionCount'],
        ),
    sourceId: json['sourceId'] as String?,
    targetId: json['targetId'] as String?,
  );
}

Map<String, dynamic> _$CounterpartyMergeCommandOutputToJson(
  CounterpartyMergeCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'reassignedTransactionCount':
      ?CounterpartyMergeCommandOutput._write_reassignedTransactionCount(
        instance.reassignedTransactionCount,
      ),
  'sourceId': ?instance.sourceId,
  'targetId': ?instance.targetId,
};
