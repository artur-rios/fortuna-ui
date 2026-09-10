// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommand
_$RegenerateRecoveryCodesThroughApiCommandFromJson(Map<String, dynamic> json) =>
    RegenerateRecoveryCodesThroughApiCommand(
      code: json['code'] as String?,
      recoveryCode: json['recoveryCode'] as String?,
    );

Map<String, dynamic> _$RegenerateRecoveryCodesThroughApiCommandToJson(
  RegenerateRecoveryCodesThroughApiCommand instance,
) => <String, dynamic>{
  'code': instance.code,
  'recoveryCode': instance.recoveryCode,
};
