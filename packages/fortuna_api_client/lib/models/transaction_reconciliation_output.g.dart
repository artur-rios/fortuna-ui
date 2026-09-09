// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_reconciliation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionReconciliationOutput _$TransactionReconciliationOutputFromJson(
  Map<String, dynamic> json,
) => TransactionReconciliationOutput(
  hasDiscrepancy: json['hasDiscrepancy'] as bool?,
  importJobId: json['importJobId'] as String?,
  importedAmount: (json['importedAmount'] as num?)?.toDouble(),
  importedOccurredOn: json['importedOccurredOn'] == null
      ? null
      : DateTime.parse(json['importedOccurredOn'] as String),
  importedRecordId: (json['importedRecordId'] as num?)?.toInt(),
  transactionAmount: (json['transactionAmount'] as num?)?.toDouble(),
  transactionOccurredOn: json['transactionOccurredOn'] == null
      ? null
      : DateTime.parse(json['transactionOccurredOn'] as String),
);

Map<String, dynamic> _$TransactionReconciliationOutputToJson(
  TransactionReconciliationOutput instance,
) => <String, dynamic>{
  'hasDiscrepancy': instance.hasDiscrepancy,
  'importJobId': instance.importJobId,
  'importedAmount': instance.importedAmount,
  'importedOccurredOn': instance.importedOccurredOn?.toIso8601String(),
  'importedRecordId': instance.importedRecordId,
  'transactionAmount': instance.transactionAmount,
  'transactionOccurredOn': instance.transactionOccurredOn?.toIso8601String(),
};
