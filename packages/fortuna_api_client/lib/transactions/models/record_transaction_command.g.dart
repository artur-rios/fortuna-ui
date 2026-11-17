// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommand _$RecordTransactionCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'categoryId',
      'counterparty',
      'creditCardId',
      'currencyCode',
      'description',
      'direction',
      'financialAccountId',
      'occurredOn',
      'ownerId',
      'tags',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'direction',
      'occurredOn',
    ],
  );
  return RecordTransactionCommand(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterparty: !json.containsKey('counterparty')
        ? null
        : RecordTransactionCommand._read_counterparty(json['counterparty']),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : RecordTransactionCommand._read_creditCardId(json['creditCardId']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordTransactionCommand._read_currencyCode(json['currencyCode']),
    description: !json.containsKey('description')
        ? null
        : RecordTransactionCommand._read_description(json['description']),
    direction: RecordTransactionCommand._read_direction(json['direction']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : RecordTransactionCommand._read_financialAccountId(
            json['financialAccountId'],
          ),
    occurredOn: json['occurredOn'] as String?,
    ownerId: !json.containsKey('ownerId')
        ? null
        : RecordTransactionCommand._read_ownerId(json['ownerId']),
    tags: !json.containsKey('tags')
        ? null
        : RecordTransactionCommand._read_tags(json['tags']),
  );
}

Map<String, dynamic> _$RecordTransactionCommandToJson(
  RecordTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterparty case final $value?)
    'counterparty': RecordTransactionCommand._write_counterparty($value),
  if (instance.creditCardId case final $value?)
    'creditCardId': RecordTransactionCommand._write_creditCardId($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordTransactionCommand._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': RecordTransactionCommand._write_description($value),
  'direction': ?RecordTransactionCommand._write_direction(instance.direction),
  if (instance.financialAccountId case final $value?)
    'financialAccountId': RecordTransactionCommand._write_financialAccountId(
      $value,
    ),
  'occurredOn': ?instance.occurredOn,
  if (instance.ownerId case final $value?)
    'ownerId': RecordTransactionCommand._write_ownerId($value),
  if (instance.tags case final $value?)
    'tags': RecordTransactionCommand._write_tags($value),
};
