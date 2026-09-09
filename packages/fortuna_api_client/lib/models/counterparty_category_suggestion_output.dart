// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'counterparty_category_suggestion_output.g.dart';

@JsonSerializable()
class CounterpartyCategorySuggestionOutput {
  const CounterpartyCategorySuggestionOutput({
    this.categoryId,
    this.categoryName,
    this.counterpartyId,
    this.hasSuggestion,
  });

  factory CounterpartyCategorySuggestionOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CounterpartyCategorySuggestionOutputFromJson(json);

  final String? categoryId;
  final String? categoryName;
  final String? counterpartyId;
  final bool? hasSuggestion;

  Map<String, Object?> toJson() =>
      _$CounterpartyCategorySuggestionOutputToJson(this);
}
