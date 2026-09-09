// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_output.dart';
import 'transaction_totals_output.dart';

part 'transaction_search_output.g.dart';

@JsonSerializable()
class TransactionSearchOutput {
  const TransactionSearchOutput({
    this.items,
    this.pageNumber,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.totals,
  });

  factory TransactionSearchOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionSearchOutputFromJson(json);

  final List<TransactionOutput>? items;
  final int? pageNumber;
  final int? pageSize;
  final int? totalItems;
  final int? totalPages;
  final TransactionTotalsOutput? totals;

  Map<String, Object?> toJson() => _$TransactionSearchOutputToJson(this);
}
