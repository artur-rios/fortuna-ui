// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyOutput _$CurrencyOutputFromJson(Map<String, dynamic> json) =>
    CurrencyOutput(
      code: json['code'] as String?,
      minorUnitDigits: (json['minorUnitDigits'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CurrencyOutputToJson(CurrencyOutput instance) =>
    <String, dynamic>{
      'code': instance.code,
      'minorUnitDigits': instance.minorUnitDigits,
      'name': instance.name,
    };
