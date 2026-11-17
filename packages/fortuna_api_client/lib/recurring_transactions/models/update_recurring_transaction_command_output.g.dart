// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_recurring_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRecurringTransactionCommandOutput
_$UpdateRecurringTransactionCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliesFrom',
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
      'lastMaterializedOn',
      'materializedOccurrencesChanged',
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
      'materializedOccurrencesChanged',
      'startsOn',
      'updatedAt',
    ],
  );
  return UpdateRecurringTransactionCommandOutput(
    amount: json['amount'] as String?,
    appliesFrom: json['appliesFrom'] as String?,
    categoryId: json['categoryId'] as String?,
    counterpartyId: json['counterpartyId'] as String?,
    counterpartyName: json['counterpartyName'] as String?,
    createdAt: UpdateRecurringTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: UpdateRecurringTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    endsOn: json['endsOn'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    frequency: UpdateRecurringTransactionCommandOutput._read_frequency(
      json['frequency'],
    ),
    id: json['id'] as String?,
    lastMaterializedOn: json['lastMaterializedOn'] as String?,
    materializedOccurrencesChanged:
        json['materializedOccurrencesChanged'] as bool?,
    nextOccurrences: (json['nextOccurrences'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    startsOn: json['startsOn'] as String?,
    updatedAt: UpdateRecurringTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$UpdateRecurringTransactionCommandOutputToJson(
  UpdateRecurringTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliesFrom': ?instance.appliesFrom,
  'categoryId': ?instance.categoryId,
  'counterpartyId': ?instance.counterpartyId,
  'counterpartyName': ?instance.counterpartyName,
  'createdAt': ?UpdateRecurringTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?UpdateRecurringTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  'endsOn': ?instance.endsOn,
  'financialAccountId': ?instance.financialAccountId,
  'frequency': ?UpdateRecurringTransactionCommandOutput._write_frequency(
    instance.frequency,
  ),
  'id': ?instance.id,
  'lastMaterializedOn': ?instance.lastMaterializedOn,
  'materializedOccurrencesChanged': ?instance.materializedOccurrencesChanged,
  'nextOccurrences': ?instance.nextOccurrences,
  'startsOn': ?instance.startsOn,
  'updatedAt': ?UpdateRecurringTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
