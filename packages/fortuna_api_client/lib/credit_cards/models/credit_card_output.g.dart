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
    currencyCode: json['currencyCode'] as String?,
    dueDay: CreditCardOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    issuer: json['issuer'] as String?,
    lastFourDigits: json['lastFourDigits'] as String?,
    name: json['name'] as String?,
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
      'currencyCode': ?instance.currencyCode,
      'dueDay': ?CreditCardOutput._write_dueDay(instance.dueDay),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      'issuer': ?instance.issuer,
      'lastFourDigits': ?instance.lastFourDigits,
      'name': ?instance.name,
      'overageAmount': ?instance.overageAmount,
      'updatedAt': ?CreditCardOutput._write_updatedAt(instance.updatedAt),
      'usedAmount': ?instance.usedAmount,
    };
