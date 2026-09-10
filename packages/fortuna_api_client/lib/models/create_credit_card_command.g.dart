// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommand _$CreateCreditCardCommandFromJson(
  Map<String, dynamic> json,
) => CreateCreditCardCommand(
  closingDay: (json['closingDay'] as num?)?.toInt(),
  creditLimit: json['creditLimit'] as String?,
  currencyCode: json['currencyCode'] as String?,
  dueDay: (json['dueDay'] as num?)?.toInt(),
  issuer: json['issuer'] as String?,
  lastFourDigits: json['lastFourDigits'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$CreateCreditCardCommandToJson(
  CreateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': instance.closingDay,
  'creditLimit': instance.creditLimit,
  'currencyCode': instance.currencyCode,
  'dueDay': instance.dueDay,
  'issuer': instance.issuer,
  'lastFourDigits': instance.lastFourDigits,
  'name': instance.name,
};
