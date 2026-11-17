// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_occurrence_materialization_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringOccurrenceMaterializationCommandOutput
_$RecurringOccurrenceMaterializationCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'error',
      'isPossibleDuplicate',
      'occurredOn',
      'transactionId',
    ],
    disallowNullValues: const ['isPossibleDuplicate', 'occurredOn'],
  );
  return RecurringOccurrenceMaterializationCommandOutput(
    error: json['error'] as String?,
    isPossibleDuplicate: json['isPossibleDuplicate'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$RecurringOccurrenceMaterializationCommandOutputToJson(
  RecurringOccurrenceMaterializationCommandOutput instance,
) => <String, dynamic>{
  'error': ?instance.error,
  'isPossibleDuplicate': ?instance.isPossibleDuplicate,
  'occurredOn': ?instance.occurredOn,
  'transactionId': ?instance.transactionId,
};
