// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_record_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportedRecordOutput _$ImportedRecordOutputFromJson(
  Map<String, dynamic> json,
) => ImportedRecordOutput(
  amount: json['amount'] as String?,
  externalId: json['externalId'] as String?,
  hasLiveTransaction: json['hasLiveTransaction'] as bool?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  outcome: json['outcome'] == null
      ? null
      : ImportedRecordOutcome.fromJson((json['outcome'] as num).toInt()),
  rawPayload: json['rawPayload'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$ImportedRecordOutputToJson(
  ImportedRecordOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'externalId': instance.externalId,
  'hasLiveTransaction': instance.hasLiveTransaction,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'outcome': _$ImportedRecordOutcomeEnumMap[instance.outcome],
  'rawPayload': instance.rawPayload,
  'rejectionReason': instance.rejectionReason,
  'transactionId': instance.transactionId,
};

const _$ImportedRecordOutcomeEnumMap = {
  ImportedRecordOutcome.value1: 1,
  ImportedRecordOutcome.value2: 2,
  ImportedRecordOutcome.value3: 3,
  ImportedRecordOutcome.$unknown: r'$unknown',
};
