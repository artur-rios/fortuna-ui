// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutput _$CreditCardOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'availableAmount',
      'closingDay',
      'createdAt',
      'creditLimit',
      'currencyCode',
      'dueDay',
      'id',
      'isDeleted',
      'issuer',
      'lastFourDigits',
      'name',
      'overageAmount',
      'updatedAt',
      'usedAmount',
    ],
    disallowNullValues: const [
      'availableAmount',
      'closingDay',
      'createdAt',
      'creditLimit',
      'dueDay',
      'id',
      'isDeleted',
      'overageAmount',
      'updatedAt',
      'usedAmount',
    ],
  );
  return CreditCardOutput(
    availableAmount: json['availableAmount'] as String?,
    closingDay: CreditCardOutput._read_closingDay(json['closingDay']),
    createdAt: CreditCardOutput._read_createdAt(json['createdAt']),
    creditLimit: json['creditLimit'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreditCardOutput._read_currencyCode(json['currencyCode']),
    dueDay: CreditCardOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    issuer: !json.containsKey('issuer')
        ? null
        : CreditCardOutput._read_issuer(json['issuer']),
    lastFourDigits: !json.containsKey('lastFourDigits')
        ? null
        : CreditCardOutput._read_lastFourDigits(json['lastFourDigits']),
    name: !json.containsKey('name')
        ? null
        : CreditCardOutput._read_name(json['name']),
    overageAmount: json['overageAmount'] as String?,
    updatedAt: CreditCardOutput._read_updatedAt(json['updatedAt']),
    usedAmount: json['usedAmount'] as String?,
  );
}

Map<String, dynamic> _$CreditCardOutputToJson(CreditCardOutput instance) =>
    <String, dynamic>{
      'availableAmount': ?instance.availableAmount,
      'closingDay': ?CreditCardOutput._write_closingDay(instance.closingDay),
      'createdAt': ?CreditCardOutput._write_createdAt(instance.createdAt),
      'creditLimit': ?instance.creditLimit,
      if (instance.currencyCode case final $value?)
        'currencyCode': CreditCardOutput._write_currencyCode($value),
      'dueDay': ?CreditCardOutput._write_dueDay(instance.dueDay),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      if (instance.issuer case final $value?)
        'issuer': CreditCardOutput._write_issuer($value),
      if (instance.lastFourDigits case final $value?)
        'lastFourDigits': CreditCardOutput._write_lastFourDigits($value),
      if (instance.name case final $value?)
        'name': CreditCardOutput._write_name($value),
      'overageAmount': ?instance.overageAmount,
      'updatedAt': ?CreditCardOutput._write_updatedAt(instance.updatedAt),
      'usedAmount': ?instance.usedAmount,
    };
