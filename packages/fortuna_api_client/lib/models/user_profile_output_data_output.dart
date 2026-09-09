// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'user_profile_output.dart';

part 'user_profile_output_data_output.g.dart';

@JsonSerializable()
class UserProfileOutputDataOutput {
  const UserProfileOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory UserProfileOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$UserProfileOutputDataOutputFromJson(json);

  final UserProfileOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$UserProfileOutputDataOutputToJson(this);
}
