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
    counterparty: !json.containsKey('counterparty')
        ? null
        : UpdateRecurringTransactionCommand._read_counterparty(
            json['counterparty'],
          ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : UpdateRecurringTransactionCommand._read_creditCardId(
            json['creditCardId'],
          ),
    description: !json.containsKey('description')
        ? null
        : UpdateRecurringTransactionCommand._read_description(
            json['description'],
          ),
    direction: UpdateRecurringTransactionCommand._read_direction(
      json['direction'],
    ),
    endsOn: !json.containsKey('endsOn')
        ? null
        : UpdateRecurringTransactionCommand._read_endsOn(json['endsOn']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : UpdateRecurringTransactionCommand._read_financialAccountId(
            json['financialAccountId'],
          ),
    frequency: UpdateRecurringTransactionCommand._read_frequency(
      json['frequency'],
    ),
    ownerId: !json.containsKey('ownerId')
        ? null
        : UpdateRecurringTransactionCommand._read_ownerId(json['ownerId']),
    startsOn: json['startsOn'] as String?,
  );
}

Map<String, dynamic> _$UpdateRecurringTransactionCommandToJson(
  UpdateRecurringTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterparty case final $value?)
    'counterparty': UpdateRecurringTransactionCommand._write_counterparty(
      $value,
    ),
  if (instance.creditCardId case final $value?)
    'creditCardId': UpdateRecurringTransactionCommand._write_creditCardId(
      $value,
    ),
  if (instance.description case final $value?)
    'description': UpdateRecurringTransactionCommand._write_description($value),
  'direction': ?UpdateRecurringTransactionCommand._write_direction(
    instance.direction,
  ),
  if (instance.endsOn case final $value?)
    'endsOn': UpdateRecurringTransactionCommand._write_endsOn($value),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        UpdateRecurringTransactionCommand._write_financialAccountId($value),
  'frequency': ?UpdateRecurringTransactionCommand._write_frequency(
    instance.frequency,
  ),
  if (instance.ownerId case final $value?)
    'ownerId': UpdateRecurringTransactionCommand._write_ownerId($value),
  'startsOn': ?instance.startsOn,
};
