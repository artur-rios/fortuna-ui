// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_category_transactions_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignCategoryTransactionsCommandOutput
_$ReassignCategoryTransactionsCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'id',
      'includeDescendants',
      'reassignedCount',
      'targetCategoryId',
    ],
    disallowNullValues: const [
      'id',
      'includeDescendants',
      'reassignedCount',
      'targetCategoryId',
    ],
  );
  return ReassignCategoryTransactionsCommandOutput(
    id: json['id'] as String?,
    includeDescendants: json['includeDescendants'] as bool?,
    reassignedCount:
        ReassignCategoryTransactionsCommandOutput._read_reassignedCount(
          json['reassignedCount'],
        ),
    targetCategoryId: json['targetCategoryId'] as String?,
  );
}

Map<String, dynamic> _$ReassignCategoryTransactionsCommandOutputToJson(
  ReassignCategoryTransactionsCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'includeDescendants': ?instance.includeDescendants,
  'reassignedCount':
      ?ReassignCategoryTransactionsCommandOutput._write_reassignedCount(
        instance.reassignedCount,
      ),
  'targetCategoryId': ?instance.targetCategoryId,
};
