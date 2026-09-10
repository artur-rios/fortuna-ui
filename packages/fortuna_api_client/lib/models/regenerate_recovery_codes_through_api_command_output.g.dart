// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_recovery_codes_through_api_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateRecoveryCodesThroughApiCommandOutput
_$RegenerateRecoveryCodesThroughApiCommandOutputFromJson(
  Map<String, dynamic> json,
) => RegenerateRecoveryCodesThroughApiCommandOutput(
  recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RegenerateRecoveryCodesThroughApiCommandOutputToJson(
  RegenerateRecoveryCodesThroughApiCommandOutput instance,
) => <String, dynamic>{'recoveryCodes': instance.recoveryCodes};
