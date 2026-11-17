// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommandOutput _$UpdateCreditCardCommandOutputFromJson(
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
  return UpdateCreditCardCommandOutput(
    closingDay: UpdateCreditCardCommandOutput._read_closingDay(
      json['closingDay'],
    ),
    createdAt: UpdateCreditCardCommandOutput._read_createdAt(json['createdAt']),
    creditLimit: json['creditLimit'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateCreditCardCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    dueDay: UpdateCreditCardCommandOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    issuer: !json.containsKey('issuer')
        ? null
        : UpdateCreditCardCommandOutput._read_issuer(json['issuer']),
    lastFourDigits: !json.containsKey('lastFourDigits')
        ? null
        : UpdateCreditCardCommandOutput._read_lastFourDigits(
            json['lastFourDigits'],
          ),
    name: !json.containsKey('name')
        ? null
        : UpdateCreditCardCommandOutput._read_name(json['name']),
    updatedAt: UpdateCreditCardCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandOutputToJson(
  UpdateCreditCardCommandOutput instance,
) => <String, dynamic>{
  'closingDay': ?UpdateCreditCardCommandOutput._write_closingDay(
    instance.closingDay,
  ),
  'createdAt': ?UpdateCreditCardCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'creditLimit': ?instance.creditLimit,
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateCreditCardCommandOutput._write_currencyCode($value),
  'dueDay': ?UpdateCreditCardCommandOutput._write_dueDay(instance.dueDay),
  'id': ?instance.id,
  if (instance.issuer case final $value?)
    'issuer': UpdateCreditCardCommandOutput._write_issuer($value),
  if (instance.lastFourDigits case final $value?)
    'lastFourDigits': UpdateCreditCardCommandOutput._write_lastFourDigits(
      $value,
    ),
  if (instance.name case final $value?)
    'name': UpdateCreditCardCommandOutput._write_name($value),
  'updatedAt': ?UpdateCreditCardCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
