// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum BudgetPeriodType {
  @JsonValue(1)
  value1(1),
  @JsonValue(2)
  value2(2),
  @JsonValue(3)
  value3(3),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const BudgetPeriodType(this.json);

  factory BudgetPeriodType.fromJson(int json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final int? json;

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<BudgetPeriodType> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
