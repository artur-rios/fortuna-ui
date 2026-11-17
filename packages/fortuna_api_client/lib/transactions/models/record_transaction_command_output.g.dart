// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommandOutput _$RecordTransactionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'categoryId',
      'categoryName',
      'counterpartyId',
      'counterpartyName',
      'createdAt',
      'creditCardId',
      'currencyCode',
      'description',
      'direction',
      'financialAccountId',
      'id',
      'isLateArriving',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'statementClosingDate',
      'statementDueDate',
      'statementId',
      'statementPeriodEnd',
      'statementPeriodStart',
      'statementPurchaseTotal',
      'statementStatus',
      'tags',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'createdAt',
      'direction',
      'id',
      'isLateArriving',
      'occurredOn',
      'updatedAt',
    ],
  );
  return RecordTransactionCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
    counterpartyId: json['counterpartyId'] as String?,
    counterpartyName: json['counterpartyName'] as String?,
    createdAt: RecordTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: RecordTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    financialAccountId: json['financialAccountId'] as String?,
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: json['originalAmount'] as String?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    rateDate: json['rateDate'] as String?,
    statementClosingDate: json['statementClosingDate'] as String?,
    statementDueDate: json['statementDueDate'] as String?,
    statementId: json['statementId'] as String?,
    statementPeriodEnd: json['statementPeriodEnd'] as String?,
    statementPeriodStart: json['statementPeriodStart'] as String?,
    statementPurchaseTotal: json['statementPurchaseTotal'] as String?,
    statementStatus: json['statementStatus'] as String?,
    tags: (json['tags'] as List<dynamic>?)
        ?.map((e) => TransactionTagOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    updatedAt: RecordTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$RecordTransactionCommandOutputToJson(
  RecordTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'categoryId': ?instance.categoryId,
  'categoryName': ?instance.categoryName,
  'counterpartyId': ?instance.counterpartyId,
  'counterpartyName': ?instance.counterpartyName,
  'createdAt': ?RecordTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?RecordTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  'financialAccountId': ?instance.financialAccountId,
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'occurredOn': ?instance.occurredOn,
  'originalAmount': ?instance.originalAmount,
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'rateDate': ?instance.rateDate,
  'statementClosingDate': ?instance.statementClosingDate,
  'statementDueDate': ?instance.statementDueDate,
  'statementId': ?instance.statementId,
  'statementPeriodEnd': ?instance.statementPeriodEnd,
  'statementPeriodStart': ?instance.statementPeriodStart,
  'statementPurchaseTotal': ?instance.statementPurchaseTotal,
  'statementStatus': ?instance.statementStatus,
  'tags': ?instance.tags?.map((e) => e.toJson()).toList(),
  'updatedAt': ?RecordTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
