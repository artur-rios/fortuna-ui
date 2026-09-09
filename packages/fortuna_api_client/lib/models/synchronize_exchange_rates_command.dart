// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'synchronize_exchange_rates_command.g.dart';

@JsonSerializable()
class SynchronizeExchangeRatesCommand {
  const SynchronizeExchangeRatesCommand({
    this.correlationId,
    this.requestedDate,
  });

  factory SynchronizeExchangeRatesCommand.fromJson(Map<String, Object?> json) =>
      _$SynchronizeExchangeRatesCommandFromJson(json);

  final String? correlationId;
  final DateTime? requestedDate;

  Map<String, Object?> toJson() =>
      _$SynchronizeExchangeRatesCommandToJson(this);
}
