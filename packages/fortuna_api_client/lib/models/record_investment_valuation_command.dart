// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_investment_valuation_command.g.dart';

@JsonSerializable()
class RecordInvestmentValuationCommand {
  const RecordInvestmentValuationCommand({this.id, this.value, this.valuedOn});

  factory RecordInvestmentValuationCommand.fromJson(
    Map<String, Object?> json,
  ) => _$RecordInvestmentValuationCommandFromJson(json);

  final String? id;
  final String? value;
  final DateTime? valuedOn;

  Map<String, Object?> toJson() =>
      _$RecordInvestmentValuationCommandToJson(this);
}
