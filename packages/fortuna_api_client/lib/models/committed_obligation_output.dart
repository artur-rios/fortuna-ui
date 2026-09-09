// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'committed_obligation_kind.dart';
import 'exchange_rate_source.dart';

part 'committed_obligation_output.g.dart';

@JsonSerializable()
class CommittedObligationOutput {
  const CommittedObligationOutput({
    this.amount,
    this.appliedRate,
    this.currencyCode,
    this.cycleEnd,
    this.cycleStart,
    this.daysOverdue,
    this.displayAmount,
    this.dueDate,
    this.id,
    this.isOverdue,
    this.kind,
    this.rateDate,
    this.rateSource,
    this.unconvertedReason,
  });

  factory CommittedObligationOutput.fromJson(Map<String, Object?> json) =>
      _$CommittedObligationOutputFromJson(json);

  final double? amount;
  final double? appliedRate;
  final String? currencyCode;
  final DateTime? cycleEnd;
  final DateTime? cycleStart;
  final int? daysOverdue;
  final double? displayAmount;
  final DateTime? dueDate;
  final String? id;
  final bool? isOverdue;
  final CommittedObligationKind? kind;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$CommittedObligationOutputToJson(this);
}
