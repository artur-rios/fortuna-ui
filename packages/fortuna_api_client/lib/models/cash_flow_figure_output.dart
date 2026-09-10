// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cash_flow_figure_kind.dart';

part 'cash_flow_figure_output.g.dart';

@JsonSerializable()
class CashFlowFigureOutput {
  const CashFlowFigureOutput({this.amount, this.kind});

  factory CashFlowFigureOutput.fromJson(Map<String, Object?> json) =>
      _$CashFlowFigureOutputFromJson(json);

  final String? amount;
  final CashFlowFigureKind? kind;

  Map<String, Object?> toJson() => _$CashFlowFigureOutputToJson(this);
}
