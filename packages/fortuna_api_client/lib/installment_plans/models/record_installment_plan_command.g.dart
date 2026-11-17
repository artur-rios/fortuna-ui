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
    counterparty: json['counterparty'] as String?,
    creditCardId: json['creditCardId'] as String?,
    currencyCode: json['currencyCode'] as String?,
    installmentCount: RecordInstallmentPlanCommand._read_installmentCount(
      json['installmentCount'],
    ),
    ownerId: json['ownerId'] as String?,
    purchasedOn: json['purchasedOn'] as String?,
    totalAmount: json['totalAmount'] as String?,
  );
}

Map<String, dynamic> _$RecordInstallmentPlanCommandToJson(
  RecordInstallmentPlanCommand instance,
) => <String, dynamic>{
  'categoryId': ?instance.categoryId,
  'counterparty': ?instance.counterparty,
  'creditCardId': ?instance.creditCardId,
  'currencyCode': ?instance.currencyCode,
  'installmentCount': ?RecordInstallmentPlanCommand._write_installmentCount(
    instance.installmentCount,
  ),
  'ownerId': ?instance.ownerId,
  'purchasedOn': ?instance.purchasedOn,
  'totalAmount': ?instance.totalAmount,
};
