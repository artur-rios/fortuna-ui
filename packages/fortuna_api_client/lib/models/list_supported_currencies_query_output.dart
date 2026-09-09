// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'currency_output.dart';

part 'list_supported_currencies_query_output.g.dart';

@JsonSerializable()
class ListSupportedCurrenciesQueryOutput {
  const ListSupportedCurrenciesQueryOutput({this.currencies});

  factory ListSupportedCurrenciesQueryOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ListSupportedCurrenciesQueryOutputFromJson(json);

  final List<CurrencyOutput>? currencies;

  Map<String, Object?> toJson() =>
      _$ListSupportedCurrenciesQueryOutputToJson(this);
}
