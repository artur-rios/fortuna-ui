// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommandOutput
_$SettleCreditCardStatementCommandOutputFromJson(Map<String, dynamic> json) =>
    SettleCreditCardStatementCommandOutput(
      appliedAmount: (json['appliedAmount'] as num?)?.toDouble(),
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      carryStatementId: json['carryStatementId'] as String?,
      creditAmount: (json['creditAmount'] as num?)?.toDouble(),
      creditCardCurrencyCode: json['creditCardCurrencyCode'] as String?,
      financialAccountId: json['financialAccountId'] as String?,
      id: json['id'] as String?,
      inboundTransactionId: json['inboundTransactionId'] as String?,
      outboundTransactionId: json['outboundTransactionId'] as String?,
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble(),
      paymentCurrencyCode: json['paymentCurrencyCode'] as String?,
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      remainingBalance: (json['remainingBalance'] as num?)?.toDouble(),
      statementAmountDue: (json['statementAmountDue'] as num?)?.toDouble(),
      status: json['status'] as String?,
      transferId: json['transferId'] as String?,
    );

Map<String, dynamic> _$SettleCreditCardStatementCommandOutputToJson(
  SettleCreditCardStatementCommandOutput instance,
) => <String, dynamic>{
  'appliedAmount': instance.appliedAmount,
  'appliedRate': instance.appliedRate,
  'carryStatementId': instance.carryStatementId,
  'creditAmount': instance.creditAmount,
  'creditCardCurrencyCode': instance.creditCardCurrencyCode,
  'financialAccountId': instance.financialAccountId,
  'id': instance.id,
  'inboundTransactionId': instance.inboundTransactionId,
  'outboundTransactionId': instance.outboundTransactionId,
  'paymentAmount': instance.paymentAmount,
  'paymentCurrencyCode': instance.paymentCurrencyCode,
  'paymentDate': instance.paymentDate?.toIso8601String(),
  'rateDate': instance.rateDate?.toIso8601String(),
  'remainingBalance': instance.remainingBalance,
  'statementAmountDue': instance.statementAmountDue,
  'status': instance.status,
  'transferId': instance.transferId,
};
