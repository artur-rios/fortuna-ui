// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommand _$RecordTransferCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'destinationFinancialAccountId',
      'destinationStatementId',
      'occurredOn',
      'originFinancialAccountId',
      'ownerId',
    ],
    disallowNullValues: const [
      'amount',
      'occurredOn',
      'originFinancialAccountId',
    ],
  );
  return RecordTransferCommand(
    amount: json['amount'] as String?,
    destinationFinancialAccountId:
        json['destinationFinancialAccountId'] as String?,
    destinationStatementId: json['destinationStatementId'] as String?,
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    ownerId: json['ownerId'] as String?,
  );
}

Map<String, dynamic> _$RecordTransferCommandToJson(
  RecordTransferCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'destinationFinancialAccountId': ?instance.destinationFinancialAccountId,
  'destinationStatementId': ?instance.destinationStatementId,
  'occurredOn': ?instance.occurredOn,
  'originFinancialAccountId': ?instance.originFinancialAccountId,
  'ownerId': ?instance.ownerId,
};
