// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'figure_amount_input.g.dart';

@JsonSerializable()
class FigureAmountInput {
  const FigureAmountInput({this.amount, this.currencyCode});

  factory FigureAmountInput.fromJson(Map<String, Object?> json) =>
      _$FigureAmountInputFromJson(json);

  final double? amount;
  final String? currencyCode;

  Map<String, Object?> toJson() => _$FigureAmountInputToJson(this);
}
