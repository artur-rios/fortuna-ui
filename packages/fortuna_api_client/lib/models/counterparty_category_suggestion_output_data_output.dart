// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'counterparty_category_suggestion_output.dart';

part 'counterparty_category_suggestion_output_data_output.g.dart';

@JsonSerializable()
class CounterpartyCategorySuggestionOutputDataOutput {
  const CounterpartyCategorySuggestionOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory CounterpartyCategorySuggestionOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CounterpartyCategorySuggestionOutputDataOutputFromJson(json);

  final CounterpartyCategorySuggestionOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$CounterpartyCategorySuggestionOutputDataOutputToJson(this);
}
