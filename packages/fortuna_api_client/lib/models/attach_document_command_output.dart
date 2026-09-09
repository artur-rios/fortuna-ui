// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'attach_document_command_output.g.dart';

@JsonSerializable()
class AttachDocumentCommandOutput {
  const AttachDocumentCommandOutput({
    this.contentType,
    this.createdAt,
    this.fileName,
    this.id,
    this.sizeInBytes,
    this.transactionId,
  });

  factory AttachDocumentCommandOutput.fromJson(Map<String, Object?> json) =>
      _$AttachDocumentCommandOutputFromJson(json);

  final String? contentType;
  final DateTime? createdAt;
  final String? fileName;
  final String? id;
  final int? sizeInBytes;
  final String? transactionId;

  Map<String, Object?> toJson() => _$AttachDocumentCommandOutputToJson(this);
}
