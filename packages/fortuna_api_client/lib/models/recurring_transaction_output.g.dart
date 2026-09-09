// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutput _$RecurringTransactionOutputFromJson(
  Map<String, dynamic> json,
) => RecurringTransactionOutput(
  amount: (json['amount'] as num?)?.toDouble(),
  categoryId: json['categoryId'] as String?,
  counterpartyId: json['counterpartyId'] as String?,
  counterpartyName: json['counterpartyName'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
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
  id: json['id'] as String?,
  lastMaterializedOn: json['lastMaterializedOn'] == null
      ? null
      : DateTime.parse(json['lastMaterializedOn'] as String),
  nextOccurrences: (json['nextOccurrences'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList(),
  startsOn: json['startsOn'] == null
      ? null
      : DateTime.parse(json['startsOn'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecurringTransactionOutputToJson(
  RecurringTransactionOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'counterpartyId': instance.counterpartyId,
  'counterpartyName': instance.counterpartyName,
  'createdAt': instance.createdAt?.toIso8601String(),
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'description': instance.description,
  'direction': _$TransactionDirectionEnumMap[instance.direction],
  'endsOn': instance.endsOn?.toIso8601String(),
  'financialAccountId': instance.financialAccountId,
  'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency],
  'id': instance.id,
  'lastMaterializedOn': instance.lastMaterializedOn?.toIso8601String(),
  'nextOccurrences': instance.nextOccurrences
      ?.map((e) => e.toIso8601String())
      .toList(),
  'startsOn': instance.startsOn?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.value1: 1,
  TransactionDirection.value2: 2,
  TransactionDirection.$unknown: r'$unknown',
};

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.value1: 1,
  RecurrenceFrequency.value2: 2,
  RecurrenceFrequency.value3: 3,
  RecurrenceFrequency.value4: 4,
  RecurrenceFrequency.$unknown: r'$unknown',
};
