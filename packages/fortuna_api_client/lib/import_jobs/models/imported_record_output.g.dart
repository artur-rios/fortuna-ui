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
    amount: json['amount'] as String?,
    externalId: json['externalId'] as String?,
    hasLiveTransaction: json['hasLiveTransaction'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    outcome: ImportedRecordOutput._read_outcome(json['outcome']),
    rawPayload: json['rawPayload'] as String?,
    rejectionReason: json['rejectionReason'] as String?,
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$ImportedRecordOutputToJson(
  ImportedRecordOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'externalId': ?instance.externalId,
  'hasLiveTransaction': ?instance.hasLiveTransaction,
  'occurredOn': ?instance.occurredOn,
  'outcome': ?ImportedRecordOutput._write_outcome(instance.outcome),
  'rawPayload': ?instance.rawPayload,
  'rejectionReason': ?instance.rejectionReason,
  'transactionId': ?instance.transactionId,
};
