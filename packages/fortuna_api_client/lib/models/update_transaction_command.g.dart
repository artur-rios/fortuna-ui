// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCommand _$UpdateTransactionCommandFromJson(
  Map<String, dynamic> json,
) => UpdateTransactionCommand(
  amount: (json['amount'] as num?)?.toDouble(),
  categoryId: json['categoryId'] as String?,
  counterparty: json['counterparty'] as String?,
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  description: json['description'] as String?,
  direction: json['direction'] == null
      ? null
      : TransactionDirection.fromJson((json['direction'] as num).toInt()),
  financialAccountId: json['financialAccountId'] as String?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  ownerId: json['ownerId'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateTransactionCommandToJson(
  UpdateTransactionCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'counterparty': instance.counterparty,
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'description': instance.description,
  'direction': instance.direction,
  'financialAccountId': instance.financialAccountId,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'ownerId': instance.ownerId,
  'tags': instance.tags,
};
