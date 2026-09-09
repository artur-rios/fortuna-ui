// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'connection_status.dart';
import 'transaction_source_type.dart';

part 'connection_output.g.dart';

@JsonSerializable()
class ConnectionOutput {
  const ConnectionOutput({
    this.createdAt,
    this.dataSourceType,
    this.externalReference,
    this.id,
    this.status,
    this.updatedAt,
  });

  factory ConnectionOutput.fromJson(Map<String, Object?> json) =>
      _$ConnectionOutputFromJson(json);

  final DateTime? createdAt;
  final TransactionSourceType? dataSourceType;
  final String? externalReference;
  final String? id;
  final ConnectionStatus? status;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$ConnectionOutputToJson(this);
}
