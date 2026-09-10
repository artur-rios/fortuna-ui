// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'committed_obligation_period_output.g.dart';

@JsonSerializable()
class CommittedObligationPeriodOutput {
  const CommittedObligationPeriodOutput({
    this.isFullyConverted,
    this.periodEnd,
    this.periodStart,
    this.total,
  });

  factory CommittedObligationPeriodOutput.fromJson(Map<String, Object?> json) =>
      _$CommittedObligationPeriodOutputFromJson(json);

  final bool? isFullyConverted;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final String? total;

  Map<String, Object?> toJson() =>
      _$CommittedObligationPeriodOutputToJson(this);
}
