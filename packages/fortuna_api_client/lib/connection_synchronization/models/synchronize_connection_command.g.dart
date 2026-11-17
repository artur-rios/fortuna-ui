// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommand _$SynchronizeConnectionCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['periodEnd', 'periodStart']);
  return SynchronizeConnectionCommand(
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
  );
}

Map<String, dynamic> _$SynchronizeConnectionCommandToJson(
  SynchronizeConnectionCommand instance,
) => <String, dynamic>{
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
};
