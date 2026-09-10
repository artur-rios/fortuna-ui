// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommandOutput _$ReconcileTransactionCommandOutputFromJson(
  Map<String, dynamic> json,
) => ReconcileTransactionCommandOutput(
  amount: json['amount'] as String?,
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  isReconciled: json['isReconciled'] as bool?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  reconciliation: json['reconciliation'] == null
      ? null
      : TransactionReconciliationOutput.fromJson(
          json['reconciliation'] as Map<String, dynamic>,
        ),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReconcileTransactionCommandOutputToJson(
  ReconcileTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'isReconciled': instance.isReconciled,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'reconciliation': instance.reconciliation,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
