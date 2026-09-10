// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommandOutput _$RecordInstallmentPlanCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecordInstallmentPlanCommandOutput(
  appliedRate: json['appliedRate'] as String?,
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  installmentCount: (json['installmentCount'] as num?)?.toInt(),
  installments: (json['installments'] as List<dynamic>?)
      ?.map((e) => InstallmentCommandOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  originalCurrencyCode: json['originalCurrencyCode'] as String?,
  originalTotalAmount: json['originalTotalAmount'] as String?,
  purchasedOn: json['purchasedOn'] == null
      ? null
      : DateTime.parse(json['purchasedOn'] as String),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  totalAmount: json['totalAmount'] as String?,
);

Map<String, dynamic> _$RecordInstallmentPlanCommandOutputToJson(
  RecordInstallmentPlanCommandOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'installmentCount': instance.installmentCount,
  'installments': instance.installments,
  'originalCurrencyCode': instance.originalCurrencyCode,
  'originalTotalAmount': instance.originalTotalAmount,
  'purchasedOn': instance.purchasedOn?.toIso8601String(),
  'rateDate': instance.rateDate?.toIso8601String(),
  'totalAmount': instance.totalAmount,
};
