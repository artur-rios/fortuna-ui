// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentOutput _$InstallmentOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'currencyCode',
      'isDeleted',
      'isLateArriving',
      'number',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'statementId',
      'transactionId',
    ],
    disallowNullValues: const [
      'amount',
      'isDeleted',
      'isLateArriving',
      'number',
      'occurredOn',
      'transactionId',
    ],
  );
  return InstallmentOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    currencyCode: json['currencyCode'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    isLateArriving: json['isLateArriving'] as bool?,
    number: InstallmentOutput._read_number(json['number']),
    occurredOn: json['occurredOn'] as String?,
    originalAmount: json['originalAmount'] as String?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    rateDate: json['rateDate'] as String?,
    statementId: json['statementId'] as String?,
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$InstallmentOutputToJson(InstallmentOutput instance) =>
    <String, dynamic>{
      'amount': ?instance.amount,
      'appliedRate': ?instance.appliedRate,
      'currencyCode': ?instance.currencyCode,
      'isDeleted': ?instance.isDeleted,
      'isLateArriving': ?instance.isLateArriving,
      'number': ?InstallmentOutput._write_number(instance.number),
      'occurredOn': ?instance.occurredOn,
      'originalAmount': ?instance.originalAmount,
      'originalCurrencyCode': ?instance.originalCurrencyCode,
      'rateDate': ?instance.rateDate,
      'statementId': ?instance.statementId,
      'transactionId': ?instance.transactionId,
    };
