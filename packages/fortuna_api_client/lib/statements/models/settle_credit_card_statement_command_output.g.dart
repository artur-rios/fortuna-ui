// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommandOutput
_$SettleCreditCardStatementCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedAmount',
      'appliedRate',
      'carryStatementId',
      'creditAmount',
      'creditCardCurrencyCode',
      'financialAccountId',
      'id',
      'inboundTransactionId',
      'outboundTransactionId',
      'paymentAmount',
      'paymentCurrencyCode',
      'paymentDate',
      'rateDate',
      'remainingBalance',
      'statementAmountDue',
      'status',
      'transferId',
    ],
    disallowNullValues: const [
      'appliedAmount',
      'creditAmount',
      'financialAccountId',
      'id',
      'inboundTransactionId',
      'outboundTransactionId',
      'paymentAmount',
      'paymentDate',
      'remainingBalance',
      'statementAmountDue',
      'transferId',
    ],
  );
  return SettleCreditCardStatementCommandOutput(
    appliedAmount: json['appliedAmount'] as String?,
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : SettleCreditCardStatementCommandOutput._read_appliedRate(
            json['appliedRate'],
          ),
    carryStatementId: !json.containsKey('carryStatementId')
        ? null
        : SettleCreditCardStatementCommandOutput._read_carryStatementId(
            json['carryStatementId'],
          ),
    creditAmount: json['creditAmount'] as String?,
    creditCardCurrencyCode: !json.containsKey('creditCardCurrencyCode')
        ? null
        : SettleCreditCardStatementCommandOutput._read_creditCardCurrencyCode(
            json['creditCardCurrencyCode'],
          ),
    financialAccountId: json['financialAccountId'] as String?,
    id: json['id'] as String?,
    inboundTransactionId: json['inboundTransactionId'] as String?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    paymentAmount: json['paymentAmount'] as String?,
    paymentCurrencyCode: !json.containsKey('paymentCurrencyCode')
        ? null
        : SettleCreditCardStatementCommandOutput._read_paymentCurrencyCode(
            json['paymentCurrencyCode'],
          ),
    paymentDate: json['paymentDate'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : SettleCreditCardStatementCommandOutput._read_rateDate(
            json['rateDate'],
          ),
    remainingBalance: json['remainingBalance'] as String?,
    statementAmountDue: json['statementAmountDue'] as String?,
    status: !json.containsKey('status')
        ? null
        : SettleCreditCardStatementCommandOutput._read_status(json['status']),
    transferId: json['transferId'] as String?,
  );
}

Map<String, dynamic> _$SettleCreditCardStatementCommandOutputToJson(
  SettleCreditCardStatementCommandOutput instance,
) => <String, dynamic>{
  'appliedAmount': ?instance.appliedAmount,
  if (instance.appliedRate case final $value?)
    'appliedRate': SettleCreditCardStatementCommandOutput._write_appliedRate(
      $value,
    ),
  if (instance.carryStatementId case final $value?)
    'carryStatementId':
        SettleCreditCardStatementCommandOutput._write_carryStatementId($value),
  'creditAmount': ?instance.creditAmount,
  if (instance.creditCardCurrencyCode case final $value?)
    'creditCardCurrencyCode':
        SettleCreditCardStatementCommandOutput._write_creditCardCurrencyCode(
          $value,
        ),
  'financialAccountId': ?instance.financialAccountId,
  'id': ?instance.id,
  'inboundTransactionId': ?instance.inboundTransactionId,
  'outboundTransactionId': ?instance.outboundTransactionId,
  'paymentAmount': ?instance.paymentAmount,
  if (instance.paymentCurrencyCode case final $value?)
    'paymentCurrencyCode':
        SettleCreditCardStatementCommandOutput._write_paymentCurrencyCode(
          $value,
        ),
  'paymentDate': ?instance.paymentDate,
  if (instance.rateDate case final $value?)
    'rateDate': SettleCreditCardStatementCommandOutput._write_rateDate($value),
  'remainingBalance': ?instance.remainingBalance,
  'statementAmountDue': ?instance.statementAmountDue,
  if (instance.status case final $value?)
    'status': SettleCreditCardStatementCommandOutput._write_status($value),
  'transferId': ?instance.transferId,
};
