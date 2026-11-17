// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommandOutput
_$MaterializeRecurringTransactionsCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdCount',
      'materializedThrough',
      'possibleDuplicateCount',
      'rules',
    ],
    disallowNullValues: const [
      'createdCount',
      'materializedThrough',
      'possibleDuplicateCount',
    ],
  );
  return MaterializeRecurringTransactionsCommandOutput(
    createdCount:
        MaterializeRecurringTransactionsCommandOutput._read_createdCount(
          json['createdCount'],
        ),
    materializedThrough: json['materializedThrough'] as String?,
    possibleDuplicateCount:
        MaterializeRecurringTransactionsCommandOutput._read_possibleDuplicateCount(
          json['possibleDuplicateCount'],
        ),
    rules: (json['rules'] as List<dynamic>?)
        ?.map(
          (e) => RecurringRuleMaterializationCommandOutput.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
  );
}

Map<String, dynamic> _$MaterializeRecurringTransactionsCommandOutputToJson(
  MaterializeRecurringTransactionsCommandOutput instance,
) => <String, dynamic>{
  'createdCount':
      ?MaterializeRecurringTransactionsCommandOutput._write_createdCount(
        instance.createdCount,
      ),
  'materializedThrough': ?instance.materializedThrough,
  'possibleDuplicateCount':
      ?MaterializeRecurringTransactionsCommandOutput._write_possibleDuplicateCount(
        instance.possibleDuplicateCount,
      ),
  'rules': ?instance.rules?.map((e) => e.toJson()).toList(),
};
