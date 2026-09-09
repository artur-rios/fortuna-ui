// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'converted_currency_group_output.dart';

part 'convert_figure_query_output.g.dart';

@JsonSerializable()
class ConvertFigureQueryOutput {
  const ConvertFigureQueryOutput({
    this.displayCurrencyCode,
    this.figureDate,
    this.groups,
    this.isFullyConverted,
    this.total,
  });

  factory ConvertFigureQueryOutput.fromJson(Map<String, Object?> json) =>
      _$ConvertFigureQueryOutputFromJson(json);

  final String? displayCurrencyCode;
  final DateTime? figureDate;
  final List<ConvertedCurrencyGroupOutput>? groups;
  final bool? isFullyConverted;
  final double? total;

  Map<String, Object?> toJson() => _$ConvertFigureQueryOutputToJson(this);
}
