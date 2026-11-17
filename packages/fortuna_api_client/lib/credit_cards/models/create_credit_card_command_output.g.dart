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
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateCreditCardCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    dueDay: CreateCreditCardCommandOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    issuer: !json.containsKey('issuer')
        ? null
        : CreateCreditCardCommandOutput._read_issuer(json['issuer']),
    lastFourDigits: !json.containsKey('lastFourDigits')
        ? null
        : CreateCreditCardCommandOutput._read_lastFourDigits(
            json['lastFourDigits'],
          ),
    name: !json.containsKey('name')
        ? null
        : CreateCreditCardCommandOutput._read_name(json['name']),
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
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateCreditCardCommandOutput._write_currencyCode($value),
  'dueDay': ?CreateCreditCardCommandOutput._write_dueDay(instance.dueDay),
  'id': ?instance.id,
  if (instance.issuer case final $value?)
    'issuer': CreateCreditCardCommandOutput._write_issuer($value),
  if (instance.lastFourDigits case final $value?)
    'lastFourDigits': CreateCreditCardCommandOutput._write_lastFourDigits(
      $value,
    ),
  if (instance.name case final $value?)
    'name': CreateCreditCardCommandOutput._write_name($value),
  'updatedAt': ?CreateCreditCardCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
