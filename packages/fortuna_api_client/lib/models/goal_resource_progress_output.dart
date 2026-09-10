// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_source.dart';
import 'goal_resource_type.dart';

part 'goal_resource_progress_output.g.dart';

@JsonSerializable()
class GoalResourceProgressOutput {
  const GoalResourceProgressOutput({
    this.appliedRate,
    this.convertedAmount,
    this.exclusionReason,
    this.id,
    this.isIncluded,
    this.name,
    this.rateDate,
    this.rateSource,
    this.resourceType,
    this.sourceAmount,
    this.sourceCurrencyCode,
    this.unconvertedReason,
  });

  factory GoalResourceProgressOutput.fromJson(Map<String, Object?> json) =>
      _$GoalResourceProgressOutputFromJson(json);

  final String? appliedRate;
  final String? convertedAmount;
  final String? exclusionReason;
  final String? id;
  final bool? isIncluded;
  final String? name;
  final DateTime? rateDate;
  final ExchangeRateSource? rateSource;
  final GoalResourceType? resourceType;
  final String? sourceAmount;
  final String? sourceCurrencyCode;
  final String? unconvertedReason;

  Map<String, Object?> toJson() => _$GoalResourceProgressOutputToJson(this);
}
