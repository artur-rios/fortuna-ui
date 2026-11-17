// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'define_recurring_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefineRecurringTransactionCommandOutput
_$DefineRecurringTransactionCommandOutputFromJson(Map<String, dynamic> json) {
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
      'nextOccurrences',
      'startsOn',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'createdAt',
      'direction',
      'frequency',
      'id',
      'startsOn',
    ],
  );
  return DefineRecurringTransactionCommandOutput(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterpartyId: json['counterpartyId'] as String?,
    counterpartyName: json['counterpartyName'] as String?,
    createdAt: DefineRecurringTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: DefineRecurringTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    endsOn: json['endsOn'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    frequency: DefineRecurringTransactionCommandOutput._read_frequency(
      json['frequency'],
    ),
    id: json['id'] as String?,
    nextOccurrences: (json['nextOccurrences'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    startsOn: json['startsOn'] as String?,
  );
}

Map<String, dynamic> _$DefineRecurringTransactionCommandOutputToJson(
  DefineRecurringTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  'counterpartyId': ?instance.counterpartyId,
  'counterpartyName': ?instance.counterpartyName,
  'createdAt': ?DefineRecurringTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?DefineRecurringTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  'endsOn': ?instance.endsOn,
  'financialAccountId': ?instance.financialAccountId,
  'frequency': ?DefineRecurringTransactionCommandOutput._write_frequency(
    instance.frequency,
  ),
  'id': ?instance.id,
  'nextOccurrences': ?instance.nextOccurrences,
  'startsOn': ?instance.startsOn,
};
