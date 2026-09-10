// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommandOutput _$RecordTransactionCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecordTransactionCommandOutput(
  amount: json['amount'] as String?,
  appliedRate: json['appliedRate'] as String?,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
  counterpartyId: json['counterpartyId'] as String?,
  counterpartyName: json['counterpartyName'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  description: json['description'] as String?,
  direction: json['direction'] == null
      ? null
      : TransactionDirection.fromJson((json['direction'] as num).toInt()),
  financialAccountId: json['financialAccountId'] as String?,
  id: json['id'] as String?,
  isLateArriving: json['isLateArriving'] as bool?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  originalAmount: json['originalAmount'] as String?,
  originalCurrencyCode: json['originalCurrencyCode'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  statementClosingDate: json['statementClosingDate'] == null
      ? null
      : DateTime.parse(json['statementClosingDate'] as String),
  statementDueDate: json['statementDueDate'] == null
      ? null
      : DateTime.parse(json['statementDueDate'] as String),
  statementId: json['statementId'] as String?,
  statementPeriodEnd: json['statementPeriodEnd'] == null
      ? null
      : DateTime.parse(json['statementPeriodEnd'] as String),
  statementPeriodStart: json['statementPeriodStart'] == null
      ? null
      : DateTime.parse(json['statementPeriodStart'] as String),
  statementPurchaseTotal: json['statementPurchaseTotal'] as String?,
  statementStatus: json['statementStatus'] as String?,
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => TransactionTagOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecordTransactionCommandOutputToJson(
  RecordTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'appliedRate': instance.appliedRate,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'counterpartyId': instance.counterpartyId,
  'counterpartyName': instance.counterpartyName,
  'createdAt': instance.createdAt?.toIso8601String(),
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'description': instance.description,
  'direction': _$TransactionDirectionEnumMap[instance.direction],
  'financialAccountId': instance.financialAccountId,
  'id': instance.id,
  'isLateArriving': instance.isLateArriving,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'originalAmount': instance.originalAmount,
  'originalCurrencyCode': instance.originalCurrencyCode,
  'rateDate': instance.rateDate?.toIso8601String(),
  'statementClosingDate': instance.statementClosingDate?.toIso8601String(),
  'statementDueDate': instance.statementDueDate?.toIso8601String(),
  'statementId': instance.statementId,
  'statementPeriodEnd': instance.statementPeriodEnd?.toIso8601String(),
  'statementPeriodStart': instance.statementPeriodStart?.toIso8601String(),
  'statementPurchaseTotal': instance.statementPurchaseTotal,
  'statementStatus': instance.statementStatus,
  'tags': instance.tags,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.value1: 1,
  TransactionDirection.value2: 2,
  TransactionDirection.$unknown: r'$unknown',
};
