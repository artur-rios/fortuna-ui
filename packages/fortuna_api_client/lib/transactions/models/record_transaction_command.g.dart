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
    counterparty: json['counterparty'] as String?,
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    description: json['description'] as String?,
    direction: RecordTransactionCommand._read_direction(json['direction']),
    financialAccountId: json['financialAccountId'] as String?,
    occurredOn: json['occurredOn'] as String?,
    ownerId: json['ownerId'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$RecordTransactionCommandToJson(
  RecordTransactionCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'categoryId': ?instance.categoryId,
  'counterparty': ?instance.counterparty,
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'description': ?instance.description,
  'direction': ?RecordTransactionCommand._write_direction(instance.direction),
  'financialAccountId': ?instance.financialAccountId,
  'occurredOn': ?instance.occurredOn,
  'ownerId': ?instance.ownerId,
  'tags': ?instance.tags,
};
