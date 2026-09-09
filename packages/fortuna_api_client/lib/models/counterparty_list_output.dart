// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'counterparty_output.dart';

part 'counterparty_list_output.g.dart';

@JsonSerializable()
class CounterpartyListOutput {
  const CounterpartyListOutput({this.counterparties});

  factory CounterpartyListOutput.fromJson(Map<String, Object?> json) =>
      _$CounterpartyListOutputFromJson(json);

  final List<CounterpartyOutput>? counterparties;

  Map<String, Object?> toJson() => _$CounterpartyListOutputToJson(this);
}
