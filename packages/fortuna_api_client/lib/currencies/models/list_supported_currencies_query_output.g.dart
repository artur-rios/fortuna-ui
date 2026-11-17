// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_supported_currencies_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSupportedCurrenciesQueryOutput _$ListSupportedCurrenciesQueryOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['currencies']);
  return ListSupportedCurrenciesQueryOutput(
    currencies: !json.containsKey('currencies')
        ? null
        : ListSupportedCurrenciesQueryOutput._read_currencies(
            json['currencies'],
          ),
  );
}

Map<String, dynamic> _$ListSupportedCurrenciesQueryOutputToJson(
  ListSupportedCurrenciesQueryOutput instance,
) => <String, dynamic>{
  if (instance.currencies case final $value?)
    'currencies': ListSupportedCurrenciesQueryOutput._write_currencies($value),
};
