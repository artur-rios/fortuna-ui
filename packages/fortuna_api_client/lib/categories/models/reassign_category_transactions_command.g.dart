// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_category_transactions_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignCategoryTransactionsCommand
_$ReassignCategoryTransactionsCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['includeDescendants', 'targetCategoryId'],
    disallowNullValues: const ['includeDescendants', 'targetCategoryId'],
  );
  return ReassignCategoryTransactionsCommand(
    includeDescendants: json['includeDescendants'] as bool?,
    targetCategoryId: json['targetCategoryId'] as String?,
  );
}

Map<String, dynamic> _$ReassignCategoryTransactionsCommandToJson(
  ReassignCategoryTransactionsCommand instance,
) => <String, dynamic>{
  'includeDescendants': ?instance.includeDescendants,
  'targetCategoryId': ?instance.targetCategoryId,
};
