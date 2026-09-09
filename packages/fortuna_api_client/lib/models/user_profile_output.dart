// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user_profile_output.g.dart';

@JsonSerializable()
class UserProfileOutput {
  const UserProfileOutput({
    this.createdAt,
    this.displayCurrency,
    this.displayCurrencyRequiresConfirmation,
    this.displayName,
    this.id,
    this.updatedAt,
  });

  factory UserProfileOutput.fromJson(Map<String, Object?> json) =>
      _$UserProfileOutputFromJson(json);

  final DateTime? createdAt;
  final String? displayCurrency;
  final bool? displayCurrencyRequiresConfirmation;
  final String? displayName;
  final String? id;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$UserProfileOutputToJson(this);
}
