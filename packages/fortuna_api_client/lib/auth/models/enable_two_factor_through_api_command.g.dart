// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorThroughApiCommand _$EnableTwoFactorThroughApiCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['methods']);
  return EnableTwoFactorThroughApiCommand(
    methods: !json.containsKey('methods')
        ? null
        : EnableTwoFactorThroughApiCommand._read_methods(json['methods']),
  );
}

Map<String, dynamic> _$EnableTwoFactorThroughApiCommandToJson(
  EnableTwoFactorThroughApiCommand instance,
) => <String, dynamic>{
  if (instance.methods case final $value?)
    'methods': EnableTwoFactorThroughApiCommand._write_methods($value),
};
