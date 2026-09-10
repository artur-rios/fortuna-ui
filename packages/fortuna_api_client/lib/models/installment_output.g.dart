// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentOutput _$InstallmentOutputFromJson(Map<String, dynamic> json) =>
    InstallmentOutput(
      amount: json['amount'] as String?,
      appliedRate: json['appliedRate'] as String?,
      currencyCode: json['currencyCode'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      isLateArriving: json['isLateArriving'] as bool?,
      number: (json['number'] as num?)?.toInt(),
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      originalAmount: json['originalAmount'] as String?,
      originalCurrencyCode: json['originalCurrencyCode'] as String?,
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      statementId: json['statementId'] as String?,
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$InstallmentOutputToJson(InstallmentOutput instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'appliedRate': instance.appliedRate,
      'currencyCode': instance.currencyCode,
      'isDeleted': instance.isDeleted,
      'isLateArriving': instance.isLateArriving,
      'number': instance.number,
      'occurredOn': instance.occurredOn?.toIso8601String(),
      'originalAmount': instance.originalAmount,
      'originalCurrencyCode': instance.originalCurrencyCode,
      'rateDate': instance.rateDate?.toIso8601String(),
      'statementId': instance.statementId,
      'transactionId': instance.transactionId,
    };
