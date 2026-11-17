// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommand _$UpdateCreditCardCommandFromJson(
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
      'name',
    ],
    disallowNullValues: const ['closingDay', 'creditLimit', 'dueDay'],
  );
  return UpdateCreditCardCommand(
    closingDay: UpdateCreditCardCommand._read_closingDay(json['closingDay']),
    creditLimit: json['creditLimit'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateCreditCardCommand._read_currencyCode(json['currencyCode']),
    dueDay: UpdateCreditCardCommand._read_dueDay(json['dueDay']),
    issuer: !json.containsKey('issuer')
        ? null
        : UpdateCreditCardCommand._read_issuer(json['issuer']),
    name: !json.containsKey('name')
        ? null
        : UpdateCreditCardCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandToJson(
  UpdateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': ?UpdateCreditCardCommand._write_closingDay(instance.closingDay),
  'creditLimit': ?instance.creditLimit,
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateCreditCardCommand._write_currencyCode($value),
  'dueDay': ?UpdateCreditCardCommand._write_dueDay(instance.dueDay),
  if (instance.issuer case final $value?)
    'issuer': UpdateCreditCardCommand._write_issuer($value),
  if (instance.name case final $value?)
    'name': UpdateCreditCardCommand._write_name($value),
};
