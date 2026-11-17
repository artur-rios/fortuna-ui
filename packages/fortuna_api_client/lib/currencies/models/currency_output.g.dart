// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyOutput _$CurrencyOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['code', 'minorUnitDigits', 'name'],
    disallowNullValues: const ['minorUnitDigits'],
  );
  return CurrencyOutput(
    code: json['code'] as String?,
    minorUnitDigits: CurrencyOutput._read_minorUnitDigits(
      json['minorUnitDigits'],
    ),
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$CurrencyOutputToJson(CurrencyOutput instance) =>
    <String, dynamic>{
      'code': ?instance.code,
      'minorUnitDigits': ?CurrencyOutput._write_minorUnitDigits(
        instance.minorUnitDigits,
      ),
      'name': ?instance.name,
    };
