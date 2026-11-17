// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutput _$CreditCardStatementOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amountDue',
      'closingDate',
      'createdAt',
      'creditCardId',
      'currencyCode',
      'dueDate',
      'foreignTaxTotal',
      'id',
      'otherEntries',
      'paymentsReceived',
      'periodEnd',
      'periodStart',
      'previousBalance',
      'purchaseTotal',
      'settlementTransactionId',
      'status',
      'transactions',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amountDue',
      'closingDate',
      'createdAt',
      'creditCardId',
      'dueDate',
      'foreignTaxTotal',
      'id',
      'otherEntries',
      'paymentsReceived',
      'periodEnd',
      'periodStart',
      'previousBalance',
      'purchaseTotal',
      'updatedAt',
    ],
  );
  return CreditCardStatementOutput(
    amountDue: json['amountDue'] as String?,
    closingDate: json['closingDate'] as String?,
    createdAt: CreditCardStatementOutput._read_createdAt(json['createdAt']),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    dueDate: json['dueDate'] as String?,
    foreignTaxTotal: json['foreignTaxTotal'] as String?,
    id: json['id'] as String?,
    otherEntries: json['otherEntries'] as String?,
    paymentsReceived: json['paymentsReceived'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
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
    updatedAt: CreditCardStatementOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputToJson(
  CreditCardStatementOutput instance,
) => <String, dynamic>{
  'amountDue': ?instance.amountDue,
  'closingDate': ?instance.closingDate,
  'createdAt': ?CreditCardStatementOutput._write_createdAt(instance.createdAt),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'dueDate': ?instance.dueDate,
  'foreignTaxTotal': ?instance.foreignTaxTotal,
  'id': ?instance.id,
  'otherEntries': ?instance.otherEntries,
  'paymentsReceived': ?instance.paymentsReceived,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'previousBalance': ?instance.previousBalance,
  'purchaseTotal': ?instance.purchaseTotal,
  'settlementTransactionId': ?instance.settlementTransactionId,
  'status': ?instance.status,
  'transactions': ?instance.transactions?.map((e) => e.toJson()).toList(),
  'updatedAt': ?CreditCardStatementOutput._write_updatedAt(instance.updatedAt),
};
