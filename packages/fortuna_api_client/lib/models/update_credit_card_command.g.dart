// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommand _$UpdateCreditCardCommandFromJson(
  Map<String, dynamic> json,
) => UpdateCreditCardCommand(
  closingDay: (json['closingDay'] as num?)?.toInt(),
  creditLimit: json['creditLimit'] as String?,
  currencyCode: json['currencyCode'] as String?,
  dueDay: (json['dueDay'] as num?)?.toInt(),
  issuer: json['issuer'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$UpdateCreditCardCommandToJson(
  UpdateCreditCardCommand instance,
) => <String, dynamic>{
  'closingDay': instance.closingDay,
  'creditLimit': instance.creditLimit,
  'currencyCode': instance.currencyCode,
  'dueDay': instance.dueDay,
  'issuer': instance.issuer,
  'name': instance.name,
};
