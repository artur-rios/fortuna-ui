// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommand _$CreateCreditCardCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'closingDay',
      'creditLimit',
      'currencyCode',
      'dueDay',
      'issuer',
      'lastFourDigits',
      'name',
    ],
    disallowNullValues: const ['closingDay', 'creditLimit', 'dueDay'],
  );
  return CreateCreditCardCommand(
    closingDay: CreateCreditCardCommand._read_closingDay(json['closingDay']),
    creditLimit: json['creditLimit'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreateCreditCardCommand._read_currencyCode(json['currencyCode']),
    dueDay: CreateCreditCardCommand._read_dueDay(json['dueDay']),
    issuer: !json.containsKey('issuer')
        ? null
        : CreateCreditCardCommand._read_issuer(json['issuer']),
    lastFourDigits: !json.containsKey('lastFourDigits')
        ? null
        : CreateCreditCardCommand._read_lastFourDigits(json['lastFourDigits']),
    name: !json.containsKey('name')
        ? null
        : CreateCreditCardCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$CreateCreditCardCommandToJson(
  CreateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': ?CreateCreditCardCommand._write_closingDay(instance.closingDay),
  'creditLimit': ?instance.creditLimit,
  if (instance.currencyCode case final $value?)
    'currencyCode': CreateCreditCardCommand._write_currencyCode($value),
  'dueDay': ?CreateCreditCardCommand._write_dueDay(instance.dueDay),
  if (instance.issuer case final $value?)
    'issuer': CreateCreditCardCommand._write_issuer($value),
  if (instance.lastFourDigits case final $value?)
    'lastFourDigits': CreateCreditCardCommand._write_lastFourDigits($value),
  if (instance.name case final $value?)
    'name': CreateCreditCardCommand._write_name($value),
};
