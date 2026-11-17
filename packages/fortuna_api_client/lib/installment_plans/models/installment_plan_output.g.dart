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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : InstallmentPlanOutput._read_appliedRate(json['appliedRate']),
    createdAt: InstallmentPlanOutput._read_createdAt(json['createdAt']),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : InstallmentPlanOutput._read_currencyCode(json['currencyCode']),
    id: json['id'] as String?,
    installmentCount: InstallmentPlanOutput._read_installmentCount(
      json['installmentCount'],
    ),
    installments: !json.containsKey('installments')
        ? null
        : InstallmentPlanOutput._read_installments(json['installments']),
    isDeleted: json['isDeleted'] as bool?,
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : InstallmentPlanOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    originalTotalAmount: !json.containsKey('originalTotalAmount')
        ? null
        : InstallmentPlanOutput._read_originalTotalAmount(
            json['originalTotalAmount'],
          ),
    purchasedOn: json['purchasedOn'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : InstallmentPlanOutput._read_rateDate(json['rateDate']),
    totalAmount: json['totalAmount'] as String?,
    updatedAt: InstallmentPlanOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$InstallmentPlanOutputToJson(
  InstallmentPlanOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': InstallmentPlanOutput._write_appliedRate($value),
  'createdAt': ?InstallmentPlanOutput._write_createdAt(instance.createdAt),
  'creditCardId': ?instance.creditCardId,
  if (instance.currencyCode case final $value?)
    'currencyCode': InstallmentPlanOutput._write_currencyCode($value),
  'id': ?instance.id,
  'installmentCount': ?InstallmentPlanOutput._write_installmentCount(
    instance.installmentCount,
  ),
  if (instance.installments case final $value?)
    'installments': InstallmentPlanOutput._write_installments($value),
  'isDeleted': ?instance.isDeleted,
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode': InstallmentPlanOutput._write_originalCurrencyCode(
      $value,
    ),
  if (instance.originalTotalAmount case final $value?)
    'originalTotalAmount': InstallmentPlanOutput._write_originalTotalAmount(
      $value,
    ),
  'purchasedOn': ?instance.purchasedOn,
  if (instance.rateDate case final $value?)
    'rateDate': InstallmentPlanOutput._write_rateDate($value),
  'totalAmount': ?instance.totalAmount,
  'updatedAt': ?InstallmentPlanOutput._write_updatedAt(instance.updatedAt),
};
