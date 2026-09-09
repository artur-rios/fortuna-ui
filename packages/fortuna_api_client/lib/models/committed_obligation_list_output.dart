// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'committed_obligation_output.dart';
import 'committed_obligation_period_output.dart';
import 'committed_obligation_rate_output.dart';

part 'committed_obligation_list_output.g.dart';

@JsonSerializable()
class CommittedObligationListOutput {
  const CommittedObligationListOutput({
    this.asOf,
    this.displayCurrencyCode,
    this.isFullyConverted,
    this.items,
    this.periods,
    this.rates,
    this.through,
    this.total,
  });

  factory CommittedObligationListOutput.fromJson(Map<String, Object?> json) =>
      _$CommittedObligationListOutputFromJson(json);

  final DateTime? asOf;
  final String? displayCurrencyCode;
  final bool? isFullyConverted;
  final List<CommittedObligationOutput>? items;
  final List<CommittedObligationPeriodOutput>? periods;
  final List<CommittedObligationRateOutput>? rates;
  final DateTime? through;
  final double? total;

  Map<String, Object?> toJson() => _$CommittedObligationListOutputToJson(this);
}
