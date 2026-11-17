// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_reconciliation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionReconciliationOutput _$TransactionReconciliationOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'hasDiscrepancy',
      'importJobId',
      'importedAmount',
      'importedOccurredOn',
      'importedRecordId',
      'transactionAmount',
      'transactionOccurredOn',
    ],
    disallowNullValues: const [
      'hasDiscrepancy',
      'importJobId',
      'importedAmount',
      'importedOccurredOn',
      'importedRecordId',
      'transactionAmount',
      'transactionOccurredOn',
    ],
  );
  return TransactionReconciliationOutput(
    hasDiscrepancy: json['hasDiscrepancy'] as bool?,
    importJobId: json['importJobId'] as String?,
    importedAmount: json['importedAmount'] as String?,
    importedOccurredOn: json['importedOccurredOn'] as String?,
    importedRecordId: TransactionReconciliationOutput._read_importedRecordId(
      json['importedRecordId'],
    ),
    transactionAmount: json['transactionAmount'] as String?,
    transactionOccurredOn: json['transactionOccurredOn'] as String?,
  );
}

Map<String, dynamic> _$TransactionReconciliationOutputToJson(
  TransactionReconciliationOutput instance,
) => <String, dynamic>{
  'hasDiscrepancy': ?instance.hasDiscrepancy,
  'importJobId': ?instance.importJobId,
  'importedAmount': ?instance.importedAmount,
  'importedOccurredOn': ?instance.importedOccurredOn,
  'importedRecordId': ?TransactionReconciliationOutput._write_importedRecordId(
    instance.importedRecordId,
  ),
  'transactionAmount': ?instance.transactionAmount,
  'transactionOccurredOn': ?instance.transactionOccurredOn,
};
