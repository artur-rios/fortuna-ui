// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_recurring_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRecurringTransactionCommand _$UpdateRecurringTransactionCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'categoryId',
      'counterparty',
      'creditCardId',
      'description',
      'direction',
      'endsOn',
      'financialAccountId',
      'frequency',
      'ownerId',
      'startsOn',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'direction',
      'frequency',
      'startsOn',
    ],
  );
  return UpdateRecurringTransactionCommand(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterparty: json['counterparty'] as String?,
    creditCardId: json['creditCardId'] as String?,
    description: json['description'] as String?,
    direction: UpdateRecurringTransactionCommand._read_direction(
      json['direction'],
    ),
    endsOn: json['endsOn'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    frequency: UpdateRecurringTransactionCommand._read_frequency(
      json['frequency'],
    ),
    ownerId: json['ownerId'] as String?,
    startsOn: json['startsOn'] as String?,
  );
}

Map<String, dynamic> _$UpdateRecurringTransactionCommandToJson(
  UpdateRecurringTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  'counterparty': ?instance.counterparty,
  'creditCardId': ?instance.creditCardId,
  'description': ?instance.description,
  'direction': ?UpdateRecurringTransactionCommand._write_direction(
    instance.direction,
  ),
  'endsOn': ?instance.endsOn,
  'financialAccountId': ?instance.financialAccountId,
  'frequency': ?UpdateRecurringTransactionCommand._write_frequency(
    instance.frequency,
  ),
  'ownerId': ?instance.ownerId,
  'startsOn': ?instance.startsOn,
};
