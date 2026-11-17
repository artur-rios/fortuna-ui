// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommandOutput _$RecordInstallmentPlanCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'creditCardId',
      'currencyCode',
      'id',
      'installmentCount',
      'installments',
      'originalCurrencyCode',
      'originalTotalAmount',
      'purchasedOn',
      'rateDate',
      'totalAmount',
    ],
    disallowNullValues: const [
      'creditCardId',
      'id',
      'installmentCount',
      'purchasedOn',
      'totalAmount',
    ],
  );
  return RecordInstallmentPlanCommandOutput(
    appliedRate: json['appliedRate'] as String?,
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    installmentCount: RecordInstallmentPlanCommandOutput._read_installmentCount(
      json['installmentCount'],
    ),
    installments: (json['installments'] as List<dynamic>?)
        ?.map(
          (e) => InstallmentCommandOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    originalTotalAmount: json['originalTotalAmount'] as String?,
    purchasedOn: json['purchasedOn'] as String?,
    rateDate: json['rateDate'] as String?,
    totalAmount: json['totalAmount'] as String?,
  );
}

Map<String, dynamic> _$RecordInstallmentPlanCommandOutputToJson(
  RecordInstallmentPlanCommandOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'installmentCount':
      ?RecordInstallmentPlanCommandOutput._write_installmentCount(
        instance.installmentCount,
      ),
  'installments': ?instance.installments?.map((e) => e.toJson()).toList(),
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'originalTotalAmount': ?instance.originalTotalAmount,
  'purchasedOn': ?instance.purchasedOn,
  'rateDate': ?instance.rateDate,
  'totalAmount': ?instance.totalAmount,
};
