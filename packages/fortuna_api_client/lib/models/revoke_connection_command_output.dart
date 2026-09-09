// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'connection_status.dart';
import 'transaction_source_type.dart';

part 'revoke_connection_command_output.g.dart';

@JsonSerializable()
class RevokeConnectionCommandOutput {
  const RevokeConnectionCommandOutput({
    this.createdAt,
    this.dataSourceType,
    this.externalReference,
    this.id,
    this.importedDataRetained,
    this.status,
    this.stoppedSynchronizations,
    this.updatedAt,
  });

  factory RevokeConnectionCommandOutput.fromJson(Map<String, Object?> json) =>
      _$RevokeConnectionCommandOutputFromJson(json);

  final DateTime? createdAt;
  final TransactionSourceType? dataSourceType;
  final String? externalReference;
  final String? id;
  final bool? importedDataRetained;
  final ConnectionStatus? status;
  final int? stoppedSynchronizations;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$RevokeConnectionCommandOutputToJson(this);
}
