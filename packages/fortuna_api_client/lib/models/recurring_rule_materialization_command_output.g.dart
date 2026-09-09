// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rule_materialization_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringRuleMaterializationCommandOutput
_$RecurringRuleMaterializationCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecurringRuleMaterializationCommandOutput(
  createdCount: (json['createdCount'] as num?)?.toInt(),
  isComplete: json['isComplete'] as bool?,
  occurrences: (json['occurrences'] as List<dynamic>?)
      ?.map(
        (e) => RecurringOccurrenceMaterializationCommandOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  possibleDuplicateCount: (json['possibleDuplicateCount'] as num?)?.toInt(),
  ruleId: json['ruleId'] as String?,
  skipReason: json['skipReason'] as String?,
);

Map<String, dynamic> _$RecurringRuleMaterializationCommandOutputToJson(
  RecurringRuleMaterializationCommandOutput instance,
) => <String, dynamic>{
  'createdCount': instance.createdCount,
  'isComplete': instance.isComplete,
  'occurrences': instance.occurrences,
  'possibleDuplicateCount': instance.possibleDuplicateCount,
  'ruleId': instance.ruleId,
  'skipReason': instance.skipReason,
};
