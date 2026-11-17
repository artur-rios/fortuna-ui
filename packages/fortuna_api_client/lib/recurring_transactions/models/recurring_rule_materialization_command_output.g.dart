// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rule_materialization_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringRuleMaterializationCommandOutput
_$RecurringRuleMaterializationCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdCount',
      'isComplete',
      'occurrences',
      'possibleDuplicateCount',
      'ruleId',
      'skipReason',
    ],
    disallowNullValues: const [
      'createdCount',
      'isComplete',
      'possibleDuplicateCount',
      'ruleId',
    ],
  );
  return RecurringRuleMaterializationCommandOutput(
    createdCount: RecurringRuleMaterializationCommandOutput._read_createdCount(
      json['createdCount'],
    ),
    isComplete: json['isComplete'] as bool?,
    occurrences: (json['occurrences'] as List<dynamic>?)
        ?.map(
          (e) => RecurringOccurrenceMaterializationCommandOutput.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    possibleDuplicateCount:
        RecurringRuleMaterializationCommandOutput._read_possibleDuplicateCount(
          json['possibleDuplicateCount'],
        ),
    ruleId: json['ruleId'] as String?,
    skipReason: json['skipReason'] as String?,
  );
}

Map<String, dynamic> _$RecurringRuleMaterializationCommandOutputToJson(
  RecurringRuleMaterializationCommandOutput instance,
) => <String, dynamic>{
  'createdCount':
      ?RecurringRuleMaterializationCommandOutput._write_createdCount(
        instance.createdCount,
      ),
  'isComplete': ?instance.isComplete,
  'occurrences': ?instance.occurrences?.map((e) => e.toJson()).toList(),
  'possibleDuplicateCount':
      ?RecurringRuleMaterializationCommandOutput._write_possibleDuplicateCount(
        instance.possibleDuplicateCount,
      ),
  'ruleId': ?instance.ruleId,
  'skipReason': ?instance.skipReason,
};
