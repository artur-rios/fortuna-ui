// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommandOutput _$UpdateCreditCardCommandOutputFromJson(
  Map<String, dynamic> json,
) => UpdateCreditCardCommandOutput(
  closingDay: (json['closingDay'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  creditLimit: json['creditLimit'] as String?,
  currencyCode: json['currencyCode'] as String?,
  dueDay: (json['dueDay'] as num?)?.toInt(),
  id: json['id'] as String?,
  issuer: json['issuer'] as String?,
  lastFourDigits: json['lastFourDigits'] as String?,
  name: json['name'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UpdateCreditCardCommandOutputToJson(
  UpdateCreditCardCommandOutput instance,
) => <String, dynamic>{
  'closingDay': instance.closingDay,
  'createdAt': instance.createdAt?.toIso8601String(),
  'creditLimit': instance.creditLimit,
  'currencyCode': instance.currencyCode,
  'dueDay': instance.dueDay,
  'id': instance.id,
  'issuer': instance.issuer,
  'lastFourDigits': instance.lastFourDigits,
  'name': instance.name,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
