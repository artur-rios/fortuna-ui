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
    currencyCode: json['currencyCode'] as String?,
    dueDay: UpdateCreditCardCommandOutput._read_dueDay(json['dueDay']),
    id: json['id'] as String?,
    issuer: json['issuer'] as String?,
    lastFourDigits: json['lastFourDigits'] as String?,
    name: json['name'] as String?,
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
  'currencyCode': ?instance.currencyCode,
  'dueDay': ?UpdateCreditCardCommandOutput._write_dueDay(instance.dueDay),
  'id': ?instance.id,
  'issuer': ?instance.issuer,
  'lastFourDigits': ?instance.lastFourDigits,
  'name': ?instance.name,
  'updatedAt': ?UpdateCreditCardCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
