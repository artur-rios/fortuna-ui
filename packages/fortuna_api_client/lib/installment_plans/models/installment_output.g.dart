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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : InstallmentOutput._read_appliedRate(json['appliedRate']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : InstallmentOutput._read_currencyCode(json['currencyCode']),
    isDeleted: json['isDeleted'] as bool?,
    isLateArriving: json['isLateArriving'] as bool?,
    number: InstallmentOutput._read_number(json['number']),
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : InstallmentOutput._read_originalAmount(json['originalAmount']),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : InstallmentOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : InstallmentOutput._read_rateDate(json['rateDate']),
    statementId: !json.containsKey('statementId')
        ? null
        : InstallmentOutput._read_statementId(json['statementId']),
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$InstallmentOutputToJson(InstallmentOutput instance) =>
    <String, dynamic>{
      'amount': ?instance.amount,
      if (instance.appliedRate case final $value?)
        'appliedRate': InstallmentOutput._write_appliedRate($value),
      if (instance.currencyCode case final $value?)
        'currencyCode': InstallmentOutput._write_currencyCode($value),
      'isDeleted': ?instance.isDeleted,
      'isLateArriving': ?instance.isLateArriving,
      'number': ?InstallmentOutput._write_number(instance.number),
      'occurredOn': ?instance.occurredOn,
      if (instance.originalAmount case final $value?)
        'originalAmount': InstallmentOutput._write_originalAmount($value),
      if (instance.originalCurrencyCode case final $value?)
        'originalCurrencyCode': InstallmentOutput._write_originalCurrencyCode(
          $value,
        ),
      if (instance.rateDate case final $value?)
        'rateDate': InstallmentOutput._write_rateDate($value),
      if (instance.statementId case final $value?)
        'statementId': InstallmentOutput._write_statementId($value),
      'transactionId': ?instance.transactionId,
    };
