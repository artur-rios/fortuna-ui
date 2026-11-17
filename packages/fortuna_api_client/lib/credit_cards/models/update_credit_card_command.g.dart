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
    currencyCode: json['currencyCode'] as String?,
    dueDay: UpdateCreditCardCommand._read_dueDay(json['dueDay']),
    issuer: json['issuer'] as String?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandToJson(
  UpdateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': ?UpdateCreditCardCommand._write_closingDay(instance.closingDay),
  'creditLimit': ?instance.creditLimit,
  'currencyCode': ?instance.currencyCode,
  'dueDay': ?UpdateCreditCardCommand._write_dueDay(instance.dueDay),
  'issuer': ?instance.issuer,
  'name': ?instance.name,
};
