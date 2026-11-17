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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : InstallmentCommandOutput._read_appliedRate(json['appliedRate']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : InstallmentCommandOutput._read_currencyCode(json['currencyCode']),
    isLateArriving: json['isLateArriving'] as bool?,
    number: InstallmentCommandOutput._read_number(json['number']),
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : InstallmentCommandOutput._read_originalAmount(json['originalAmount']),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : InstallmentCommandOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : InstallmentCommandOutput._read_rateDate(json['rateDate']),
    statementId: !json.containsKey('statementId')
        ? null
        : InstallmentCommandOutput._read_statementId(json['statementId']),
    transactionId: json['transactionId'] as String?,
  );
}

Map<String, dynamic> _$InstallmentCommandOutputToJson(
  InstallmentCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': InstallmentCommandOutput._write_appliedRate($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': InstallmentCommandOutput._write_currencyCode($value),
  'isLateArriving': ?instance.isLateArriving,
  'number': ?InstallmentCommandOutput._write_number(instance.number),
  'occurredOn': ?instance.occurredOn,
  if (instance.originalAmount case final $value?)
    'originalAmount': InstallmentCommandOutput._write_originalAmount($value),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode':
        InstallmentCommandOutput._write_originalCurrencyCode($value),
  if (instance.rateDate case final $value?)
    'rateDate': InstallmentCommandOutput._write_rateDate($value),
  if (instance.statementId case final $value?)
    'statementId': InstallmentCommandOutput._write_statementId($value),
  'transactionId': ?instance.transactionId,
};
