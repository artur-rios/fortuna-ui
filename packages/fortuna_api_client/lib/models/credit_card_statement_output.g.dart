// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutput _$CreditCardStatementOutputFromJson(
  Map<String, dynamic> json,
) => CreditCardStatementOutput(
  amountDue: json['amountDue'] as String?,
  closingDate: json['closingDate'] == null
      ? null
      : DateTime.parse(json['closingDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  foreignTaxTotal: json['foreignTaxTotal'] as String?,
  id: json['id'] as String?,
  otherEntries: json['otherEntries'] as String?,
  paymentsReceived: json['paymentsReceived'] as String?,
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  previousBalance: json['previousBalance'] as String?,
  purchaseTotal: json['purchaseTotal'] as String?,
  settlementTransactionId: json['settlementTransactionId'] as String?,
  status: json['status'] as String?,
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map(
        (e) => CreditCardStatementTransactionOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CreditCardStatementOutputToJson(
  CreditCardStatementOutput instance,
) => <String, dynamic>{
  'amountDue': instance.amountDue,
  'closingDate': instance.closingDate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'dueDate': instance.dueDate?.toIso8601String(),
  'foreignTaxTotal': instance.foreignTaxTotal,
  'id': instance.id,
  'otherEntries': instance.otherEntries,
  'paymentsReceived': instance.paymentsReceived,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'previousBalance': instance.previousBalance,
  'purchaseTotal': instance.purchaseTotal,
  'settlementTransactionId': instance.settlementTransactionId,
  'status': instance.status,
  'transactions': instance.transactions,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
