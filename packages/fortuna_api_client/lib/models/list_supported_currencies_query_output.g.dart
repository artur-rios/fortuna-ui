// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_supported_currencies_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSupportedCurrenciesQueryOutput _$ListSupportedCurrenciesQueryOutputFromJson(
  Map<String, dynamic> json,
) => ListSupportedCurrenciesQueryOutput(
  currencies: (json['currencies'] as List<dynamic>?)
      ?.map((e) => CurrencyOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListSupportedCurrenciesQueryOutputToJson(
  ListSupportedCurrenciesQueryOutput instance,
) => <String, dynamic>{'currencies': instance.currencies};
