// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_occurrence_materialization_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringOccurrenceMaterializationCommandOutput
_$RecurringOccurrenceMaterializationCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecurringOccurrenceMaterializationCommandOutput(
  error: json['error'] as String?,
  isPossibleDuplicate: json['isPossibleDuplicate'] as bool?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$RecurringOccurrenceMaterializationCommandOutputToJson(
  RecurringOccurrenceMaterializationCommandOutput instance,
) => <String, dynamic>{
  'error': instance.error,
  'isPossibleDuplicate': instance.isPossibleDuplicate,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'transactionId': instance.transactionId,
};
