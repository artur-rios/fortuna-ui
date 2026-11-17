// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommandOutput _$ReconcileTransactionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'currencyCode',
      'id',
      'isReconciled',
      'occurredOn',
      'reconciliation',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'id',
      'isReconciled',
      'occurredOn',
      'reconciliation',
      'updatedAt',
    ],
  );
  return ReconcileTransactionCommandOutput(
    amount: json['amount'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : ReconcileTransactionCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    isReconciled: json['isReconciled'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    reconciliation: json['reconciliation'] == null
        ? null
        : TransactionReconciliationOutput.fromJson(
            json['reconciliation'] as Map<String, dynamic>,
          ),
    updatedAt: ReconcileTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$ReconcileTransactionCommandOutputToJson(
  ReconcileTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.currencyCode case final $value?)
    'currencyCode': ReconcileTransactionCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  'isReconciled': ?instance.isReconciled,
  'occurredOn': ?instance.occurredOn,
  'reconciliation': ?instance.reconciliation?.toJson(),
  'updatedAt': ?ReconcileTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
