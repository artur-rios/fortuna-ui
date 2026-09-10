// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommand _$RecordInstallmentPlanCommandFromJson(
  Map<String, dynamic> json,
) => RecordInstallmentPlanCommand(
  categoryId: json['categoryId'] as String?,
  counterparty: json['counterparty'] as String?,
  creditCardId: json['creditCardId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  installmentCount: (json['installmentCount'] as num?)?.toInt(),
  ownerId: json['ownerId'] as String?,
  purchasedOn: json['purchasedOn'] == null
      ? null
      : DateTime.parse(json['purchasedOn'] as String),
  totalAmount: json['totalAmount'] as String?,
);

Map<String, dynamic> _$RecordInstallmentPlanCommandToJson(
  RecordInstallmentPlanCommand instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'counterparty': instance.counterparty,
  'creditCardId': instance.creditCardId,
  'currencyCode': instance.currencyCode,
  'installmentCount': instance.installmentCount,
  'ownerId': instance.ownerId,
  'purchasedOn': instance.purchasedOn?.toIso8601String(),
  'totalAmount': instance.totalAmount,
};
