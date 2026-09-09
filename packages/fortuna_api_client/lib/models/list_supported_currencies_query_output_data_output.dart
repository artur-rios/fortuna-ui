// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'list_supported_currencies_query_output.dart';

part 'list_supported_currencies_query_output_data_output.g.dart';

@JsonSerializable()
class ListSupportedCurrenciesQueryOutputDataOutput {
  const ListSupportedCurrenciesQueryOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ListSupportedCurrenciesQueryOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ListSupportedCurrenciesQueryOutputDataOutputFromJson(json);

  final ListSupportedCurrenciesQueryOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ListSupportedCurrenciesQueryOutputDataOutputToJson(this);
}
