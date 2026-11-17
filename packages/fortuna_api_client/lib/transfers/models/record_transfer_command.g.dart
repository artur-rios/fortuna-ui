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
        !json.containsKey('destinationFinancialAccountId')
        ? null
        : RecordTransferCommand._read_destinationFinancialAccountId(
            json['destinationFinancialAccountId'],
          ),
    destinationStatementId: !json.containsKey('destinationStatementId')
        ? null
        : RecordTransferCommand._read_destinationStatementId(
            json['destinationStatementId'],
          ),
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    ownerId: !json.containsKey('ownerId')
        ? null
        : RecordTransferCommand._read_ownerId(json['ownerId']),
  );
}

Map<String, dynamic> _$RecordTransferCommandToJson(
  RecordTransferCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.destinationFinancialAccountId case final $value?)
    'destinationFinancialAccountId':
        RecordTransferCommand._write_destinationFinancialAccountId($value),
  if (instance.destinationStatementId case final $value?)
    'destinationStatementId':
        RecordTransferCommand._write_destinationStatementId($value),
  'occurredOn': ?instance.occurredOn,
  'originFinancialAccountId': ?instance.originFinancialAccountId,
  if (instance.ownerId case final $value?)
    'ownerId': RecordTransferCommand._write_ownerId($value),
};
