// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanOutput _$InstallmentPlanOutputFromJson(
  Map<String, dynamic> json,
) => InstallmentPlanOutput(
  appliedRate: json['appliedRate'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  installmentCount: (json['installmentCount'] as num?)?.toInt(),
  installments: (json['installments'] as List<dynamic>?)
      ?.map((e) => InstallmentOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  isDeleted: json['isDeleted'] as bool?,
  originalCurrencyCode: json['originalCurrencyCode'] as String?,
  originalTotalAmount: json['originalTotalAmount'] as String?,
  purchasedOn: json['purchasedOn'] == null
      ? null
      : DateTime.parse(json['purchasedOn'] as String),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  totalAmount: json['totalAmount'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$InstallmentPlanOutputToJson(
  InstallmentPlanOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'createdAt': instance.createdAt?.toIso8601String(),
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'installmentCount': instance.installmentCount,
  'installments': instance.installments,
  'isDeleted': instance.isDeleted,
  'originalCurrencyCode': instance.originalCurrencyCode,
  'originalTotalAmount': instance.originalTotalAmount,
  'purchasedOn': instance.purchasedOn?.toIso8601String(),
  'rateDate': instance.rateDate?.toIso8601String(),
  'totalAmount': instance.totalAmount,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
