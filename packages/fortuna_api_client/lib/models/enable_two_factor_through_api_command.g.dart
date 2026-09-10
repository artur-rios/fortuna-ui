// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommand _$EnableTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) => EnableTwoFactorThroughApiCommand(
  methods: (json['methods'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$EnableTwoFactorThroughApiCommandToJson(
  EnableTwoFactorThroughApiCommand instance,
) => <String, dynamic>{'methods': instance.methods};
