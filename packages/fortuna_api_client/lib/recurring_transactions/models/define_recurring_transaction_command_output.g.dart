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
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : DefineRecurringTransactionCommandOutput._read_counterpartyId(
            json['counterpartyId'],
          ),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : DefineRecurringTransactionCommandOutput._read_counterpartyName(
            json['counterpartyName'],
          ),
    createdAt: DefineRecurringTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : DefineRecurringTransactionCommandOutput._read_creditCardId(
            json['creditCardId'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : DefineRecurringTransactionCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    description: !json.containsKey('description')
        ? null
        : DefineRecurringTransactionCommandOutput._read_description(
            json['description'],
          ),
    direction: DefineRecurringTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    endsOn: !json.containsKey('endsOn')
        ? null
        : DefineRecurringTransactionCommandOutput._read_endsOn(json['endsOn']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : DefineRecurringTransactionCommandOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    frequency: DefineRecurringTransactionCommandOutput._read_frequency(
      json['frequency'],
    ),
    id: json['id'] as String?,
    nextOccurrences: !json.containsKey('nextOccurrences')
        ? null
        : DefineRecurringTransactionCommandOutput._read_nextOccurrences(
            json['nextOccurrences'],
          ),
    startsOn: json['startsOn'] as String?,
  );
}

Map<String, dynamic> _$DefineRecurringTransactionCommandOutputToJson(
  DefineRecurringTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterpartyId case final $value?)
    'counterpartyId':
        DefineRecurringTransactionCommandOutput._write_counterpartyId($value),
  if (instance.counterpartyName case final $value?)
    'counterpartyName':
        DefineRecurringTransactionCommandOutput._write_counterpartyName($value),
  'createdAt': ?DefineRecurringTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.creditCardId case final $value?)
    'creditCardId': DefineRecurringTransactionCommandOutput._write_creditCardId(
      $value,
    ),
  if (instance.currencyCode case final $value?)
    'currencyCode': DefineRecurringTransactionCommandOutput._write_currencyCode(
      $value,
    ),
  if (instance.description case final $value?)
    'description': DefineRecurringTransactionCommandOutput._write_description(
      $value,
    ),
  'direction': ?DefineRecurringTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  if (instance.endsOn case final $value?)
    'endsOn': DefineRecurringTransactionCommandOutput._write_endsOn($value),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        DefineRecurringTransactionCommandOutput._write_financialAccountId(
          $value,
        ),
  'frequency': ?DefineRecurringTransactionCommandOutput._write_frequency(
    instance.frequency,
  ),
  'id': ?instance.id,
  if (instance.nextOccurrences case final $value?)
    'nextOccurrences':
        DefineRecurringTransactionCommandOutput._write_nextOccurrences($value),
  'startsOn': ?instance.startsOn,
};
