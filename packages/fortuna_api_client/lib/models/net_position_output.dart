// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'net_position_currency_output.dart';

part 'net_position_output.g.dart';

@JsonSerializable()
class NetPositionOutput {
  const NetPositionOutput({
    this.asOf,
    this.currencyGroups,
    this.displayCurrencyCode,
    this.isFullyConverted,
    this.total,
  });

  factory NetPositionOutput.fromJson(Map<String, Object?> json) =>
      _$NetPositionOutputFromJson(json);

  final DateTime? asOf;
  final List<NetPositionCurrencyOutput>? currencyGroups;
  final String? displayCurrencyCode;
  final bool? isFullyConverted;
  final String? total;

  Map<String, Object?> toJson() => _$NetPositionOutputToJson(this);
}
