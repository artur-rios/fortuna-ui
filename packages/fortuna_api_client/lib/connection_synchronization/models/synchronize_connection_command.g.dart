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
    periodEnd: !json.containsKey('periodEnd')
        ? null
        : SynchronizeConnectionCommand._read_periodEnd(json['periodEnd']),
    periodStart: !json.containsKey('periodStart')
        ? null
        : SynchronizeConnectionCommand._read_periodStart(json['periodStart']),
  );
}

Map<String, dynamic> _$SynchronizeConnectionCommandToJson(
  SynchronizeConnectionCommand instance,
) => <String, dynamic>{
  if (instance.periodEnd case final $value?)
    'periodEnd': SynchronizeConnectionCommand._write_periodEnd($value),
  if (instance.periodStart case final $value?)
    'periodStart': SynchronizeConnectionCommand._write_periodStart($value),
};
