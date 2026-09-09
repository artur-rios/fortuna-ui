// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'define_recurring_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefineRecurringTransactionCommand _$DefineRecurringTransactionCommandFromJson(
  Map<String, dynamic> json,
) => DefineRecurringTransactionCommand(
  amount: (json['amount'] as num?)?.toDouble(),
  categoryId: json['categoryId'] as String?,
  counterparty: json['counterparty'] as String?,
  creditCardId: json['creditCardId'] as String?,
  description: json['description'] as String?,
  direction: json['direction'] == null
      ? null
      : TransactionDirection.fromJson((json['direction'] as num).toInt()),
  endsOn: json['endsOn'] == null
      ? null
      : DateTime.parse(json['endsOn'] as String),
  financialAccountId: json['financialAccountId'] as String?,
  frequency: json['frequency'] == null
      ? null
      : RecurrenceFrequency.fromJson((json['frequency'] as num).toInt()),
  ownerId: json['ownerId'] as String?,
  startsOn: json['startsOn'] == null
      ? null
      : DateTime.parse(json['startsOn'] as String),
);

Map<String, dynamic> _$DefineRecurringTransactionCommandToJson(
  DefineRecurringTransactionCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'counterparty': instance.counterparty,
  'creditCardId': instance.creditCardId,
  'description': instance.description,
  'direction': instance.direction,
  'endsOn': instance.endsOn?.toIso8601String(),
  'financialAccountId': instance.financialAccountId,
  'frequency': instance.frequency,
  'ownerId': instance.ownerId,
  'startsOn': instance.startsOn?.toIso8601String(),
};
