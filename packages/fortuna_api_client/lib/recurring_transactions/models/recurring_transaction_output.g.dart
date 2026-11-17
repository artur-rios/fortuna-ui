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
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : RecurringTransactionOutput._read_counterpartyId(
            json['counterpartyId'],
          ),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : RecurringTransactionOutput._read_counterpartyName(
            json['counterpartyName'],
          ),
    createdAt: RecurringTransactionOutput._read_createdAt(json['createdAt']),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : RecurringTransactionOutput._read_creditCardId(json['creditCardId']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecurringTransactionOutput._read_currencyCode(json['currencyCode']),
    description: !json.containsKey('description')
        ? null
        : RecurringTransactionOutput._read_description(json['description']),
    direction: RecurringTransactionOutput._read_direction(json['direction']),
    endsOn: !json.containsKey('endsOn')
        ? null
        : RecurringTransactionOutput._read_endsOn(json['endsOn']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : RecurringTransactionOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    frequency: RecurringTransactionOutput._read_frequency(json['frequency']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    lastMaterializedOn: !json.containsKey('lastMaterializedOn')
        ? null
        : RecurringTransactionOutput._read_lastMaterializedOn(
            json['lastMaterializedOn'],
          ),
    nextOccurrences: !json.containsKey('nextOccurrences')
        ? null
        : RecurringTransactionOutput._read_nextOccurrences(
            json['nextOccurrences'],
          ),
    startsOn: json['startsOn'] as String?,
    updatedAt: RecurringTransactionOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputToJson(
  RecurringTransactionOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterpartyId case final $value?)
    'counterpartyId': RecurringTransactionOutput._write_counterpartyId($value),
  if (instance.counterpartyName case final $value?)
    'counterpartyName': RecurringTransactionOutput._write_counterpartyName(
      $value,
    ),
  'createdAt': ?RecurringTransactionOutput._write_createdAt(instance.createdAt),
  if (instance.creditCardId case final $value?)
    'creditCardId': RecurringTransactionOutput._write_creditCardId($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': RecurringTransactionOutput._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': RecurringTransactionOutput._write_description($value),
  'direction': ?RecurringTransactionOutput._write_direction(instance.direction),
  if (instance.endsOn case final $value?)
    'endsOn': RecurringTransactionOutput._write_endsOn($value),
  if (instance.financialAccountId case final $value?)
    'financialAccountId': RecurringTransactionOutput._write_financialAccountId(
      $value,
    ),
  'frequency': ?RecurringTransactionOutput._write_frequency(instance.frequency),
  'id': ?instance.id,
  'isDeleted': ?instance.isDeleted,
  if (instance.lastMaterializedOn case final $value?)
    'lastMaterializedOn': RecurringTransactionOutput._write_lastMaterializedOn(
      $value,
    ),
  if (instance.nextOccurrences case final $value?)
    'nextOccurrences': RecurringTransactionOutput._write_nextOccurrences(
      $value,
    ),
  'startsOn': ?instance.startsOn,
  'updatedAt': ?RecurringTransactionOutput._write_updatedAt(instance.updatedAt),
};
