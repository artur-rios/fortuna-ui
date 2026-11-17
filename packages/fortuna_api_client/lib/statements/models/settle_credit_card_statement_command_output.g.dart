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
    appliedRate: json['appliedRate'] as String?,
    carryStatementId: json['carryStatementId'] as String?,
    creditAmount: json['creditAmount'] as String?,
    creditCardCurrencyCode: json['creditCardCurrencyCode'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    id: json['id'] as String?,
    inboundTransactionId: json['inboundTransactionId'] as String?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    paymentAmount: json['paymentAmount'] as String?,
    paymentCurrencyCode: json['paymentCurrencyCode'] as String?,
    paymentDate: json['paymentDate'] as String?,
    rateDate: json['rateDate'] as String?,
    remainingBalance: json['remainingBalance'] as String?,
    statementAmountDue: json['statementAmountDue'] as String?,
    status: json['status'] as String?,
    transferId: json['transferId'] as String?,
  );
}

Map<String, dynamic> _$SettleCreditCardStatementCommandOutputToJson(
  SettleCreditCardStatementCommandOutput instance,
) => <String, dynamic>{
  'appliedAmount': ?instance.appliedAmount,
  'appliedRate': ?instance.appliedRate,
  'carryStatementId': ?instance.carryStatementId,
  'creditAmount': ?instance.creditAmount,
  'creditCardCurrencyCode': ?instance.creditCardCurrencyCode,
  'financialAccountId': ?instance.financialAccountId,
  'id': ?instance.id,
  'inboundTransactionId': ?instance.inboundTransactionId,
  'outboundTransactionId': ?instance.outboundTransactionId,
  'paymentAmount': ?instance.paymentAmount,
  'paymentCurrencyCode': ?instance.paymentCurrencyCode,
  'paymentDate': ?instance.paymentDate,
  'rateDate': ?instance.rateDate,
  'remainingBalance': ?instance.remainingBalance,
  'statementAmountDue': ?instance.statementAmountDue,
  'status': ?instance.status,
  'transferId': ?instance.transferId,
};
