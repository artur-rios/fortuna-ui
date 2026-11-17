// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_installment_plan_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInstallmentPlanCommand _$RecordInstallmentPlanCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'categoryId',
      'counterparty',
      'creditCardId',
      'currencyCode',
      'installmentCount',
      'ownerId',
      'purchasedOn',
      'totalAmount',
    ],
    disallowNullValues: const [
      'categoryId',
      'creditCardId',
      'installmentCount',
      'purchasedOn',
      'totalAmount',
    ],
  );
  return RecordInstallmentPlanCommand(
    categoryId: json['categoryId'] as String?,
    counterparty: !json.containsKey('counterparty')
        ? null
        : RecordInstallmentPlanCommand._read_counterparty(json['counterparty']),
    creditCardId: json['creditCardId'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordInstallmentPlanCommand._read_currencyCode(json['currencyCode']),
    installmentCount: RecordInstallmentPlanCommand._read_installmentCount(
      json['installmentCount'],
    ),
    ownerId: !json.containsKey('ownerId')
        ? null
        : RecordInstallmentPlanCommand._read_ownerId(json['ownerId']),
    purchasedOn: json['purchasedOn'] as String?,
    totalAmount: json['totalAmount'] as String?,
  );
}

Map<String, dynamic> _$RecordInstallmentPlanCommandToJson(
  RecordInstallmentPlanCommand instance,
) => <String, dynamic>{
  'categoryId': ?instance.categoryId,
  if (instance.counterparty case final $value?)
    'counterparty': RecordInstallmentPlanCommand._write_counterparty($value),
  'creditCardId': ?instance.creditCardId,
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordInstallmentPlanCommand._write_currencyCode($value),
  'installmentCount': ?RecordInstallmentPlanCommand._write_installmentCount(
    instance.installmentCount,
  ),
  if (instance.ownerId case final $value?)
    'ownerId': RecordInstallmentPlanCommand._write_ownerId($value),
  'purchasedOn': ?instance.purchasedOn,
  'totalAmount': ?instance.totalAmount,
};
