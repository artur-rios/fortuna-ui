// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutput _$RecurringTransactionOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'categoryId',
      'counterpartyId',
      'counterpartyName',
      'createdAt',
      'creditCardId',
      'currencyCode',
      'description',
      'direction',
      'endsOn',
      'financialAccountId',
      'frequency',
      'id',
      'isDeleted',
      'lastMaterializedOn',
      'nextOccurrences',
      'startsOn',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'createdAt',
      'direction',
      'frequency',
      'id',
      'isDeleted',
      'startsOn',
      'updatedAt',
    ],
  );
  return RecurringTransactionOutput(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterpartyId: json['counterpartyId'] as String?,
    counterpartyName: json['counterpartyName'] as String?,
    createdAt: RecurringTransactionOutput._read_createdAt(json['createdAt']),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: RecurringTransactionOutput._read_direction(json['direction']),
    endsOn: json['endsOn'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    frequency: RecurringTransactionOutput._read_frequency(json['frequency']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    lastMaterializedOn: json['lastMaterializedOn'] as String?,
    nextOccurrences: (json['nextOccurrences'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    startsOn: json['startsOn'] as String?,
    updatedAt: RecurringTransactionOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputToJson(
  RecurringTransactionOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  'counterpartyId': ?instance.counterpartyId,
  'counterpartyName': ?instance.counterpartyName,
  'createdAt': ?RecurringTransactionOutput._write_createdAt(instance.createdAt),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?RecurringTransactionOutput._write_direction(instance.direction),
  'endsOn': ?instance.endsOn,
  'financialAccountId': ?instance.financialAccountId,
  'frequency': ?RecurringTransactionOutput._write_frequency(instance.frequency),
  'id': ?instance.id,
  'isDeleted': ?instance.isDeleted,
  'lastMaterializedOn': ?instance.lastMaterializedOn,
  'nextOccurrences': ?instance.nextOccurrences,
  'startsOn': ?instance.startsOn,
  'updatedAt': ?RecurringTransactionOutput._write_updatedAt(instance.updatedAt),
};
