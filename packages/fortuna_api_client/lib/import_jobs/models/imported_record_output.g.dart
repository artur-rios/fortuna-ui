// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_record_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportedRecordOutput _$ImportedRecordOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'externalId',
      'hasLiveTransaction',
      'occurredOn',
      'outcome',
      'rawPayload',
      'rejectionReason',
      'transactionId',
    ],
    disallowNullValues: const ['hasLiveTransaction', 'outcome'],
  );
  return ImportedRecordOutput(
    amount: !json.containsKey('amount')
        ? null
        : ImportedRecordOutput._read_amount(json['amount']),
    externalId: !json.containsKey('externalId')
        ? null
        : ImportedRecordOutput._read_externalId(json['externalId']),
    hasLiveTransaction: json['hasLiveTransaction'] as bool?,
    occurredOn: !json.containsKey('occurredOn')
        ? null
        : ImportedRecordOutput._read_occurredOn(json['occurredOn']),
    outcome: ImportedRecordOutput._read_outcome(json['outcome']),
    rawPayload: !json.containsKey('rawPayload')
        ? null
        : ImportedRecordOutput._read_rawPayload(json['rawPayload']),
    rejectionReason: !json.containsKey('rejectionReason')
        ? null
        : ImportedRecordOutput._read_rejectionReason(json['rejectionReason']),
    transactionId: !json.containsKey('transactionId')
        ? null
        : ImportedRecordOutput._read_transactionId(json['transactionId']),
  );
}

Map<String, dynamic> _$ImportedRecordOutputToJson(
  ImportedRecordOutput instance,
) => <String, dynamic>{
  if (instance.amount case final $value?)
    'amount': ImportedRecordOutput._write_amount($value),
  if (instance.externalId case final $value?)
    'externalId': ImportedRecordOutput._write_externalId($value),
  'hasLiveTransaction': ?instance.hasLiveTransaction,
  if (instance.occurredOn case final $value?)
    'occurredOn': ImportedRecordOutput._write_occurredOn($value),
  'outcome': ?ImportedRecordOutput._write_outcome(instance.outcome),
  if (instance.rawPayload case final $value?)
    'rawPayload': ImportedRecordOutput._write_rawPayload($value),
  if (instance.rejectionReason case final $value?)
    'rejectionReason': ImportedRecordOutput._write_rejectionReason($value),
  if (instance.transactionId case final $value?)
    'transactionId': ImportedRecordOutput._write_transactionId($value),
};
