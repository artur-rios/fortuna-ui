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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : RecordInstallmentPlanCommandOutput._read_appliedRate(
            json['appliedRate'],
          ),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordInstallmentPlanCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    installmentCount: RecordInstallmentPlanCommandOutput._read_installmentCount(
      json['installmentCount'],
    ),
    installments: !json.containsKey('installments')
        ? null
        : RecordInstallmentPlanCommandOutput._read_installments(
            json['installments'],
          ),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : RecordInstallmentPlanCommandOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    originalTotalAmount: !json.containsKey('originalTotalAmount')
        ? null
        : RecordInstallmentPlanCommandOutput._read_originalTotalAmount(
            json['originalTotalAmount'],
          ),
    purchasedOn: json['purchasedOn'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : RecordInstallmentPlanCommandOutput._read_rateDate(json['rateDate']),
    totalAmount: json['totalAmount'] as String?,
  );
}

Map<String, dynamic> _$RecordInstallmentPlanCommandOutputToJson(
  RecordInstallmentPlanCommandOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': RecordInstallmentPlanCommandOutput._write_appliedRate(
      $value,
    ),
  'creditCardId': ?instance.creditCardId,
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordInstallmentPlanCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  'installmentCount':
      ?RecordInstallmentPlanCommandOutput._write_installmentCount(
        instance.installmentCount,
      ),
  if (instance.installments case final $value?)
    'installments': RecordInstallmentPlanCommandOutput._write_installments(
      $value,
    ),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode':
        RecordInstallmentPlanCommandOutput._write_originalCurrencyCode($value),
  if (instance.originalTotalAmount case final $value?)
    'originalTotalAmount':
        RecordInstallmentPlanCommandOutput._write_originalTotalAmount($value),
  'purchasedOn': ?instance.purchasedOn,
  if (instance.rateDate case final $value?)
    'rateDate': RecordInstallmentPlanCommandOutput._write_rateDate($value),
  'totalAmount': ?instance.totalAmount,
};
