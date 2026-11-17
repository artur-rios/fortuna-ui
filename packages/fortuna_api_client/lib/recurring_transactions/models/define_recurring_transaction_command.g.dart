// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'define_recurring_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefineRecurringTransactionCommand _$DefineRecurringTransactionCommandFromJson(
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
  return DefineRecurringTransactionCommand(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterparty: !json.containsKey('counterparty')
        ? null
        : DefineRecurringTransactionCommand._read_counterparty(
            json['counterparty'],
          ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : DefineRecurringTransactionCommand._read_creditCardId(
            json['creditCardId'],
          ),
    description: !json.containsKey('description')
        ? null
        : DefineRecurringTransactionCommand._read_description(
            json['description'],
          ),
    direction: DefineRecurringTransactionCommand._read_direction(
      json['direction'],
    ),
    endsOn: !json.containsKey('endsOn')
        ? null
        : DefineRecurringTransactionCommand._read_endsOn(json['endsOn']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : DefineRecurringTransactionCommand._read_financialAccountId(
            json['financialAccountId'],
          ),
    frequency: DefineRecurringTransactionCommand._read_frequency(
      json['frequency'],
    ),
    ownerId: !json.containsKey('ownerId')
        ? null
        : DefineRecurringTransactionCommand._read_ownerId(json['ownerId']),
    startsOn: json['startsOn'] as String?,
  );
}

Map<String, dynamic> _$DefineRecurringTransactionCommandToJson(
  DefineRecurringTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterparty case final $value?)
    'counterparty': DefineRecurringTransactionCommand._write_counterparty(
      $value,
    ),
  if (instance.creditCardId case final $value?)
    'creditCardId': DefineRecurringTransactionCommand._write_creditCardId(
      $value,
    ),
  if (instance.description case final $value?)
    'description': DefineRecurringTransactionCommand._write_description($value),
  'direction': ?DefineRecurringTransactionCommand._write_direction(
    instance.direction,
  ),
  if (instance.endsOn case final $value?)
    'endsOn': DefineRecurringTransactionCommand._write_endsOn($value),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        DefineRecurringTransactionCommand._write_financialAccountId($value),
  'frequency': ?DefineRecurringTransactionCommand._write_frequency(
    instance.frequency,
  ),
  if (instance.ownerId case final $value?)
    'ownerId': DefineRecurringTransactionCommand._write_ownerId($value),
  'startsOn': ?instance.startsOn,
};
