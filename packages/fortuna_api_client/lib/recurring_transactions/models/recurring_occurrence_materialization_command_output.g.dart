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
    error: !json.containsKey('error')
        ? null
        : RecurringOccurrenceMaterializationCommandOutput._read_error(
            json['error'],
          ),
    isPossibleDuplicate: json['isPossibleDuplicate'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    transactionId: !json.containsKey('transactionId')
        ? null
        : RecurringOccurrenceMaterializationCommandOutput._read_transactionId(
            json['transactionId'],
          ),
  );
}

Map<String, dynamic> _$RecurringOccurrenceMaterializationCommandOutputToJson(
  RecurringOccurrenceMaterializationCommandOutput instance,
) => <String, dynamic>{
  if (instance.error case final $value?)
    'error': RecurringOccurrenceMaterializationCommandOutput._write_error(
      $value,
    ),
  'isPossibleDuplicate': ?instance.isPossibleDuplicate,
  'occurredOn': ?instance.occurredOn,
  if (instance.transactionId case final $value?)
    'transactionId':
        RecurringOccurrenceMaterializationCommandOutput._write_transactionId(
          $value,
        ),
};
