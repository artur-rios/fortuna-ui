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
    code: !json.containsKey('code')
        ? null
        : CurrencyOutput._read_code(json['code']),
    minorUnitDigits: CurrencyOutput._read_minorUnitDigits(
      json['minorUnitDigits'],
    ),
    name: !json.containsKey('name')
        ? null
        : CurrencyOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$CurrencyOutputToJson(CurrencyOutput instance) =>
    <String, dynamic>{
      if (instance.code case final $value?)
        'code': CurrencyOutput._write_code($value),
      'minorUnitDigits': ?CurrencyOutput._write_minorUnitDigits(
        instance.minorUnitDigits,
      ),
      if (instance.name case final $value?)
        'name': CurrencyOutput._write_name($value),
    };
