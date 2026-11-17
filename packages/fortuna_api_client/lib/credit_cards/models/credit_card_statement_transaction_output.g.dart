// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementTransactionOutput
_$CreditCardStatementTransactionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'createdAt',
      'direction',
      'id',
      'isLateArriving',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'createdAt',
      'id',
      'isLateArriving',
      'occurredOn',
      'updatedAt',
    ],
  );
  return CreditCardStatementTransactionOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    createdAt: CreditCardStatementTransactionOutput._read_createdAt(
      json['createdAt'],
    ),
    direction: json['direction'] as String?,
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: json['originalAmount'] as String?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    rateDate: json['rateDate'] as String?,
    updatedAt: CreditCardStatementTransactionOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$CreditCardStatementTransactionOutputToJson(
  CreditCardStatementTransactionOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'createdAt': ?CreditCardStatementTransactionOutput._write_createdAt(
    instance.createdAt,
  ),
  'direction': ?instance.direction,
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'occurredOn': ?instance.occurredOn,
  'originalAmount': ?instance.originalAmount,
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'rateDate': ?instance.rateDate,
  'updatedAt': ?CreditCardStatementTransactionOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
