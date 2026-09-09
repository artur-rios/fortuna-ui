// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_category_transactions_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignCategoryTransactionsCommandOutput
_$ReassignCategoryTransactionsCommandOutputFromJson(
  Map<String, dynamic> json,
) => ReassignCategoryTransactionsCommandOutput(
  id: json['id'] as String?,
  includeDescendants: json['includeDescendants'] as bool?,
  reassignedCount: (json['reassignedCount'] as num?)?.toInt(),
  targetCategoryId: json['targetCategoryId'] as String?,
);

Map<String, dynamic> _$ReassignCategoryTransactionsCommandOutputToJson(
  ReassignCategoryTransactionsCommandOutput instance,
) => <String, dynamic>{
  'id': instance.id,
  'includeDescendants': instance.includeDescendants,
  'reassignedCount': instance.reassignedCount,
  'targetCategoryId': instance.targetCategoryId,
};
