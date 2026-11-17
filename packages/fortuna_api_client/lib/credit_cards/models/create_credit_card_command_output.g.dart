// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommandOutput _$CreateCreditCardCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'closingDay',
      'createdAt',
      'creditLimit',
      'currencyCode',
      'dueDay',
      'id',
      'issuer',
      'lastFourDigits',
      'name',
      'updatedAt',
    ],
    disallowNullValues: const [
      'closingDay',
      'createdAt',
      'creditLimit',
      'dueDay',
      'id',
      'updatedAt',
    ],
  );
  return CreateCreditCardCommandOutput(
    closingDay: CreateCreditCardCommandOutput._read_closingDay(
      json['closingDay'],
    ),
    createdAt: CreateCreditCardCommandOutput._read_createdAt(json['createdAt']),
    creditLimit: json['creditLimit'] as String?,
    currencyCode: json['currencyCode'] as String?,
    dueDay: CreateCreditCardCommandOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    issuer: json['issuer'] as String?,
    lastFourDigits: json['lastFourDigits'] as String?,
    name: json['name'] as String?,
    updatedAt: CreateCreditCardCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CreateCreditCardCommandOutputToJson(
  CreateCreditCardCommandOutput instance,
) => <String, dynamic>{
  'closingDay': ?CreateCreditCardCommandOutput._write_closingDay(
    instance.closingDay,
  ),
  'createdAt': ?CreateCreditCardCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditLimit': ?instance.creditLimit,
  'currencyCode': ?instance.currencyCode,
  'dueDay': ?CreateCreditCardCommandOutput._write_dueDay(instance.dueDay),
  'id': ?instance.id,
  'issuer': ?instance.issuer,
  'lastFourDigits': ?instance.lastFourDigits,
  'name': ?instance.name,
  'updatedAt': ?CreateCreditCardCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
