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
    appliesFrom: !json.containsKey('appliesFrom')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_appliesFrom(
            json['appliesFrom'],
          ),
    categoryId: json['categoryId'] as String?,
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_counterpartyId(
            json['counterpartyId'],
          ),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_counterpartyName(
            json['counterpartyName'],
          ),
    createdAt: UpdateRecurringTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_creditCardId(
            json['creditCardId'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    description: !json.containsKey('description')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_description(
            json['description'],
          ),
    direction: UpdateRecurringTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    endsOn: !json.containsKey('endsOn')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_endsOn(json['endsOn']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    frequency: UpdateRecurringTransactionCommandOutput._read_frequency(
      json['frequency'],
    ),
    id: json['id'] as String?,
    lastMaterializedOn: !json.containsKey('lastMaterializedOn')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_lastMaterializedOn(
            json['lastMaterializedOn'],
          ),
    materializedOccurrencesChanged:
        json['materializedOccurrencesChanged'] as bool?,
    nextOccurrences: !json.containsKey('nextOccurrences')
        ? null
        : UpdateRecurringTransactionCommandOutput._read_nextOccurrences(
            json['nextOccurrences'],
          ),
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
  if (instance.appliesFrom case final $value?)
    'appliesFrom': UpdateRecurringTransactionCommandOutput._write_appliesFrom(
      $value,
    ),
  'categoryId': ?instance.categoryId,
  if (instance.counterpartyId case final $value?)
    'counterpartyId':
        UpdateRecurringTransactionCommandOutput._write_counterpartyId($value),
  if (instance.counterpartyName case final $value?)
    'counterpartyName':
        UpdateRecurringTransactionCommandOutput._write_counterpartyName($value),
  'createdAt': ?UpdateRecurringTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.creditCardId case final $value?)
    'creditCardId': UpdateRecurringTransactionCommandOutput._write_creditCardId(
      $value,
    ),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateRecurringTransactionCommandOutput._write_currencyCode(
      $value,
    ),
  if (instance.description case final $value?)
    'description': UpdateRecurringTransactionCommandOutput._write_description(
      $value,
    ),
  'direction': ?UpdateRecurringTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  if (instance.endsOn case final $value?)
    'endsOn': UpdateRecurringTransactionCommandOutput._write_endsOn($value),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        UpdateRecurringTransactionCommandOutput._write_financialAccountId(
          $value,
        ),
  'frequency': ?UpdateRecurringTransactionCommandOutput._write_frequency(
    instance.frequency,
  ),
  'id': ?instance.id,
  if (instance.lastMaterializedOn case final $value?)
    'lastMaterializedOn':
        UpdateRecurringTransactionCommandOutput._write_lastMaterializedOn(
          $value,
        ),
  'materializedOccurrencesChanged': ?instance.materializedOccurrencesChanged,
  if (instance.nextOccurrences case final $value?)
    'nextOccurrences':
        UpdateRecurringTransactionCommandOutput._write_nextOccurrences($value),
  'startsOn': ?instance.startsOn,
  'updatedAt': ?UpdateRecurringTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
