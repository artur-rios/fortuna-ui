// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reconcile_transaction_command.g.dart';

@JsonSerializable()
class ReconcileTransactionCommand {
  const ReconcileTransactionCommand({
    this.importJobId,
    this.importedRecordId,
    this.unreconcile,
  });

  factory ReconcileTransactionCommand.fromJson(Map<String, Object?> json) =>
      _$ReconcileTransactionCommandFromJson(json);

  final String? importJobId;
  final int? importedRecordId;
  final bool? unreconcile;

  Map<String, Object?> toJson() => _$ReconcileTransactionCommandToJson(this);
}
