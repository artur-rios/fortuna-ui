// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'figure_amount_input.dart';

part 'convert_figure_query.g.dart';

@JsonSerializable()
class ConvertFigureQuery {
  const ConvertFigureQuery({
    this.amounts,
    this.displayCurrencyCode,
    this.figureDate,
    this.pageNumber,
    this.pageSize,
  });

  factory ConvertFigureQuery.fromJson(Map<String, Object?> json) =>
      _$ConvertFigureQueryFromJson(json);

  final List<FigureAmountInput>? amounts;
  final String? displayCurrencyCode;
  final DateTime? figureDate;
  final int? pageNumber;
  final int? pageSize;

  Map<String, Object?> toJson() => _$ConvertFigureQueryToJson(this);
}
