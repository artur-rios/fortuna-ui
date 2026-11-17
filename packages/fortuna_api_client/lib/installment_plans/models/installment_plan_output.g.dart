// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentPlanOutput _$InstallmentPlanOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'createdAt',
      'creditCardId',
      'currencyCode',
      'id',
      'installmentCount',
      'installments',
      'isDeleted',
      'originalCurrencyCode',
      'originalTotalAmount',
      'purchasedOn',
      'rateDate',
      'totalAmount',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'creditCardId',
      'id',
      'installmentCount',
      'isDeleted',
      'purchasedOn',
      'totalAmount',
      'updatedAt',
    ],
  );
  return InstallmentPlanOutput(
    appliedRate: json['appliedRate'] as String?,
    createdAt: InstallmentPlanOutput._read_createdAt(json['createdAt']),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    installmentCount: InstallmentPlanOutput._read_installmentCount(
      json['installmentCount'],
    ),
    installments: (json['installments'] as List<dynamic>?)
        ?.map((e) => InstallmentOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    isDeleted: json['isDeleted'] as bool?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    originalTotalAmount: json['originalTotalAmount'] as String?,
    purchasedOn: json['purchasedOn'] as String?,
    rateDate: json['rateDate'] as String?,
    totalAmount: json['totalAmount'] as String?,
    updatedAt: InstallmentPlanOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$InstallmentPlanOutputToJson(
  InstallmentPlanOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'createdAt': ?InstallmentPlanOutput._write_createdAt(instance.createdAt),
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'installmentCount': ?InstallmentPlanOutput._write_installmentCount(
    instance.installmentCount,
  ),
  'installments': ?instance.installments?.map((e) => e.toJson()).toList(),
  'isDeleted': ?instance.isDeleted,
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'originalTotalAmount': ?instance.originalTotalAmount,
  'purchasedOn': ?instance.purchasedOn,
  'rateDate': ?instance.rateDate,
  'totalAmount': ?instance.totalAmount,
  'updatedAt': ?InstallmentPlanOutput._write_updatedAt(instance.updatedAt),
};
