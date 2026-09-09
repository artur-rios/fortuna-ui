// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'authenticate_local_account_command_output.dart';

part 'authenticate_local_account_command_output_data_output.g.dart';

@JsonSerializable()
class AuthenticateLocalAccountCommandOutputDataOutput {
  const AuthenticateLocalAccountCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory AuthenticateLocalAccountCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$AuthenticateLocalAccountCommandOutputDataOutputFromJson(json);

  final AuthenticateLocalAccountCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$AuthenticateLocalAccountCommandOutputDataOutputToJson(this);
}
