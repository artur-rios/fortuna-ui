// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutput _$CreditCardOutputFromJson(Map<String, dynamic> json) =>
    CreditCardOutput(
      availableAmount: json['availableAmount'] as String?,
      closingDay: (json['closingDay'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      creditLimit: json['creditLimit'] as String?,
      currencyCode: json['currencyCode'] as String?,
      dueDay: (json['dueDay'] as num?)?.toInt(),
      id: json['id'] as String?,
      issuer: json['issuer'] as String?,
      lastFourDigits: json['lastFourDigits'] as String?,
      name: json['name'] as String?,
      overageAmount: json['overageAmount'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      usedAmount: json['usedAmount'] as String?,
    );

Map<String, dynamic> _$CreditCardOutputToJson(CreditCardOutput instance) =>
    <String, dynamic>{
      'availableAmount': instance.availableAmount,
      'closingDay': instance.closingDay,
      'createdAt': instance.createdAt?.toIso8601String(),
      'creditLimit': instance.creditLimit,
      'currencyCode': instance.currencyCode,
      'dueDay': instance.dueDay,
      'id': instance.id,
      'issuer': instance.issuer,
      'lastFourDigits': instance.lastFourDigits,
      'name': instance.name,
      'overageAmount': instance.overageAmount,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'usedAmount': instance.usedAmount,
    };
