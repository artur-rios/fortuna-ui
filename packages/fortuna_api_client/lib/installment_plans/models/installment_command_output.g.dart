// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentCommandOutput _$InstallmentCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'currencyCode',
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
      'isLateArriving',
      'number',
      'occurredOn',
      'transactionId',
    ],
  );
  return InstallmentCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    currencyCode: json['currencyCode'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    number: InstallmentCommandOutput._read_number(json['number']),
    occurredOn: json['occurredOn'] as String?,
    originalAmount: json['originalAmount'] as String?,
    originalCurrencyCode: json['originalCurrencyCode'] as String?,
    rateDate: json['rateDate'] as String?,
    statementId: json['statementId'] as String?,
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$InstallmentCommandOutputToJson(
  InstallmentCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'currencyCode': ?instance.currencyCode,
  'isLateArriving': ?instance.isLateArriving,
  'number': ?InstallmentCommandOutput._write_number(instance.number),
  'occurredOn': ?instance.occurredOn,
  'originalAmount': ?instance.originalAmount,
  'originalCurrencyCode': ?instance.originalCurrencyCode,
  'rateDate': ?instance.rateDate,
  'statementId': ?instance.statementId,
  'transactionId': ?instance.transactionId,
};
