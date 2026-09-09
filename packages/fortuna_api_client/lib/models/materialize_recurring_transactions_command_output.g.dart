// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommandOutput
_$MaterializeRecurringTransactionsCommandOutputFromJson(
  Map<String, dynamic> json,
) => MaterializeRecurringTransactionsCommandOutput(
  createdCount: (json['createdCount'] as num?)?.toInt(),
  materializedThrough: json['materializedThrough'] == null
      ? null
      : DateTime.parse(json['materializedThrough'] as String),
  possibleDuplicateCount: (json['possibleDuplicateCount'] as num?)?.toInt(),
  rules: (json['rules'] as List<dynamic>?)
      ?.map(
        (e) => RecurringRuleMaterializationCommandOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$MaterializeRecurringTransactionsCommandOutputToJson(
  MaterializeRecurringTransactionsCommandOutput instance,
) => <String, dynamic>{
  'createdCount': instance.createdCount,
  'materializedThrough': instance.materializedThrough?.toIso8601String(),
  'possibleDuplicateCount': instance.possibleDuplicateCount,
  'rules': instance.rules,
};
