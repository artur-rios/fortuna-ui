// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCommandOutput _$UpdateTransactionCommandOutputFromJson(
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
      'creditCardName',
      'currencyCode',
      'description',
      'direction',
      'financialAccountId',
      'financialAccountName',
      'id',
      'isLateArriving',
      'isManuallyCorrected',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'sourceType',
      'statementId',
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
      'isManuallyCorrected',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'sourceType',
      'updatedAt',
    ],
  );
  return UpdateTransactionCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    categoryId: json['categoryId'] as String?,
    categoryName: json['categoryName'] as String?,
    counterpartyId: json['counterpartyId'] as String?,
    counterpartyName: json['counterpartyName'] as String?,
    createdAt: UpdateTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: json['creditCardId'] as String?,
    creditCardName: json['creditCardName'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: UpdateTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    financialAccountId: json['financialAccountId'] as String?,
    financialAccountName: json['financialAccountName'] as String?,
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    isManuallyCorrected: json['isManuallyCorrected'] as bool?,
    isReconciled: json['isReconciled'] as bool?,
    isTransfer: json['isTransfer'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: json['originalAmount'] as String?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    rateDate: json['rateDate'] as String?,
    sourceType: UpdateTransactionCommandOutput._read_sourceType(
      json['sourceType'],
    ),
    statementId: json['statementId'] as String?,
    tags: (json['tags'] as List<dynamic>?)
        ?.map(
          (e) => UpdateTransactionTagOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    updatedAt: UpdateTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$UpdateTransactionCommandOutputToJson(
  UpdateTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'categoryId': ?instance.categoryId,
  'categoryName': ?instance.categoryName,
  'counterpartyId': ?instance.counterpartyId,
  'counterpartyName': ?instance.counterpartyName,
  'createdAt': ?UpdateTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditCardId': ?instance.creditCardId,
  'creditCardName': ?instance.creditCardName,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?UpdateTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  'financialAccountId': ?instance.financialAccountId,
  'financialAccountName': ?instance.financialAccountName,
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'isManuallyCorrected': ?instance.isManuallyCorrected,
  'isReconciled': ?instance.isReconciled,
  'isTransfer': ?instance.isTransfer,
  'occurredOn': ?instance.occurredOn,
  'originalAmount': ?instance.originalAmount,
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'rateDate': ?instance.rateDate,
  'sourceType': ?UpdateTransactionCommandOutput._write_sourceType(
    instance.sourceType,
  ),
  'statementId': ?instance.statementId,
  'tags': ?instance.tags?.map((e) => e.toJson()).toList(),
  'updatedAt': ?UpdateTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
