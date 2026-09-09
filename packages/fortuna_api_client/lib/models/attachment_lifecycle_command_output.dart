// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'attachment_lifecycle_command_output.g.dart';

@JsonSerializable()
class AttachmentLifecycleCommandOutput {
  const AttachmentLifecycleCommandOutput({this.id, this.isDeleted});

  factory AttachmentLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$AttachmentLifecycleCommandOutputFromJson(json);

  final String? id;
  final bool? isDeleted;

  Map<String, Object?> toJson() =>
      _$AttachmentLifecycleCommandOutputToJson(this);
}
