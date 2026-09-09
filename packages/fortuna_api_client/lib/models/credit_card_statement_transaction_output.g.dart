// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementTransactionOutput
_$CreditCardStatementTransactionOutputFromJson(Map<String, dynamic> json) =>
    CreditCardStatementTransactionOutput(
      amount: (json['amount'] as num?)?.toDouble(),
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      direction: json['direction'] as String?,
      id: json['id'] as String?,
      isLateArriving: json['isLateArriving'] as bool?,
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      originalCurrencyCode: json['originalCurrencyCode'] as String?,
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CreditCardStatementTransactionOutputToJson(
  CreditCardStatementTransactionOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'appliedRate': instance.appliedRate,
  'createdAt': instance.createdAt?.toIso8601String(),
  'direction': instance.direction,
  'id': instance.id,
  'isLateArriving': instance.isLateArriving,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'originalAmount': instance.originalAmount,
  'originalCurrencyCode': instance.originalCurrencyCode,
  'rateDate': instance.rateDate?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
