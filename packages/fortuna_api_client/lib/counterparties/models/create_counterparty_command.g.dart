// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_counterparty_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCounterpartyCommand _$CreateCounterpartyCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name']);
  return CreateCounterpartyCommand(
    name: !json.containsKey('name')
        ? null
        : CreateCounterpartyCommand._read_name(json['name']),
  );
}

Map<String, dynamic> _$CreateCounterpartyCommandToJson(
  CreateCounterpartyCommand instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': CreateCounterpartyCommand._write_name($value),
};
