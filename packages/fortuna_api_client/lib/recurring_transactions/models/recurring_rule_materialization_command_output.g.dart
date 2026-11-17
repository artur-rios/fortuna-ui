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
    occurrences: !json.containsKey('occurrences')
        ? null
        : RecurringRuleMaterializationCommandOutput._read_occurrences(
            json['occurrences'],
          ),
    possibleDuplicateCount:
        RecurringRuleMaterializationCommandOutput._read_possibleDuplicateCount(
          json['possibleDuplicateCount'],
        ),
    ruleId: json['ruleId'] as String?,
    skipReason: !json.containsKey('skipReason')
        ? null
        : RecurringRuleMaterializationCommandOutput._read_skipReason(
            json['skipReason'],
          ),
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
  if (instance.occurrences case final $value?)
    'occurrences': RecurringRuleMaterializationCommandOutput._write_occurrences(
      $value,
    ),
  'possibleDuplicateCount':
      ?RecurringRuleMaterializationCommandOutput._write_possibleDuplicateCount(
        instance.possibleDuplicateCount,
      ),
  'ruleId': ?instance.ruleId,
  if (instance.skipReason case final $value?)
    'skipReason': RecurringRuleMaterializationCommandOutput._write_skipReason(
      $value,
    ),
};
