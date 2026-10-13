// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'attachment_output.g.dart';

@JsonSerializable()
class AttachmentOutput {
  const AttachmentOutput({
    this.contentType,
    this.createdAt,
    this.fileName,
    this.id,
    this.isDeleted,
    this.sizeInBytes,
    this.transactionId,
    this.updatedAt,
  });

  factory AttachmentOutput.fromJson(Map<String, Object?> json) =>
      _$AttachmentOutputFromJson(json);

  final String? contentType;
  final DateTime? createdAt;
  final String? fileName;
  final String? id;
  final bool? isDeleted;
  final int? sizeInBytes;
  final String? transactionId;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$AttachmentOutputToJson(this);
}
