// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_counterparty_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCounterpartyCommand _$UpdateCounterpartyCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name']);
  return UpdateCounterpartyCommand(
    name: !json.containsKey('name')
        ? null
        : UpdateCounterpartyCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$UpdateCounterpartyCommandToJson(
  UpdateCounterpartyCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': UpdateCounterpartyCommand._write_name($value),
};
