// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCommand _$UpdateTransactionCommandFromJson(
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
  return UpdateTransactionCommand(
    amount: json['amount'] as String?,
    categoryId: json['categoryId'] as String?,
    counterparty: !json.containsKey('counterparty')
        ? null
        : UpdateTransactionCommand._read_counterparty(json['counterparty']),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : UpdateTransactionCommand._read_creditCardId(json['creditCardId']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateTransactionCommand._read_currencyCode(json['currencyCode']),
    description: !json.containsKey('description')
        ? null
        : UpdateTransactionCommand._read_description(json['description']),
    direction: UpdateTransactionCommand._read_direction(json['direction']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : UpdateTransactionCommand._read_financialAccountId(
            json['financialAccountId'],
          ),
    occurredOn: json['occurredOn'] as String?,
    ownerId: !json.containsKey('ownerId')
        ? null
        : UpdateTransactionCommand._read_ownerId(json['ownerId']),
    tags: !json.containsKey('tags')
        ? null
        : UpdateTransactionCommand._read_tags(json['tags']),
  );
}

Map<String, dynamic> _$UpdateTransactionCommandToJson(
  UpdateTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  if (instance.counterparty case final $value?)
    'counterparty': UpdateTransactionCommand._write_counterparty($value),
  if (instance.creditCardId case final $value?)
    'creditCardId': UpdateTransactionCommand._write_creditCardId($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateTransactionCommand._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': UpdateTransactionCommand._write_description($value),
  'direction': ?UpdateTransactionCommand._write_direction(instance.direction),
  if (instance.financialAccountId case final $value?)
    'financialAccountId': UpdateTransactionCommand._write_financialAccountId(
      $value,
    ),
  'occurredOn': ?instance.occurredOn,
  if (instance.ownerId case final $value?)
    'ownerId': UpdateTransactionCommand._write_ownerId($value),
  if (instance.tags case final $value?)
    'tags': UpdateTransactionCommand._write_tags($value),
};
