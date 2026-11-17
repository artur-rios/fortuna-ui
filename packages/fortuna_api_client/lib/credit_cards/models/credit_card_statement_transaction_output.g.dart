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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : CreditCardStatementTransactionOutput._read_appliedRate(
            json['appliedRate'],
          ),
    createdAt: CreditCardStatementTransactionOutput._read_createdAt(
      json['createdAt'],
    ),
    direction: !json.containsKey('direction')
        ? null
        : CreditCardStatementTransactionOutput._read_direction(
            json['direction'],
          ),
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : CreditCardStatementTransactionOutput._read_originalAmount(
            json['originalAmount'],
          ),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : CreditCardStatementTransactionOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : CreditCardStatementTransactionOutput._read_rateDate(json['rateDate']),
    updatedAt: CreditCardStatementTransactionOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$CreditCardStatementTransactionOutputToJson(
  CreditCardStatementTransactionOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': CreditCardStatementTransactionOutput._write_appliedRate(
      $value,
    ),
  'createdAt': ?CreditCardStatementTransactionOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.direction case final $value?)
    'direction': CreditCardStatementTransactionOutput._write_direction($value),
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'occurredOn': ?instance.occurredOn,
  if (instance.originalAmount case final $value?)
    'originalAmount':
        CreditCardStatementTransactionOutput._write_originalAmount($value),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode':
        CreditCardStatementTransactionOutput._write_originalCurrencyCode(
          $value,
        ),
  if (instance.rateDate case final $value?)
    'rateDate': CreditCardStatementTransactionOutput._write_rateDate($value),
  'updatedAt': ?CreditCardStatementTransactionOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
