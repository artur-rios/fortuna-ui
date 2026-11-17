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
    currencyCode: json['currencyCode'] as String?,
    dueDay: CreateCreditCardCommand._read_dueDay(json['dueDay']),
    issuer: json['issuer'] as String?,
    lastFourDigits: json['lastFourDigits'] as String?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$CreateCreditCardCommandToJson(
  CreateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': ?CreateCreditCardCommand._write_closingDay(instance.closingDay),
  'creditLimit': ?instance.creditLimit,
  'currencyCode': ?instance.currencyCode,
  'dueDay': ?CreateCreditCardCommand._write_dueDay(instance.dueDay),
  'issuer': ?instance.issuer,
  'lastFourDigits': ?instance.lastFourDigits,
  'name': ?instance.name,
};
