// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_counterparty_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCounterpartyCommand _$CreateCounterpartyCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['name']);
  return CreateCounterpartyCommand(name: json['name'] as String?);
}

Map<String, dynamic> _$CreateCounterpartyCommandToJson(
  CreateCounterpartyCommand instance,
) => <String, dynamic>{'name': ?instance.name};
