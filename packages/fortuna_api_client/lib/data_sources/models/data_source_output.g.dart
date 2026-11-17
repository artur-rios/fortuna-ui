// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceOutput _$DataSourceOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'displayName',
      'isAvailable',
      'isNetworkBacked',
      'kind',
      'name',
      'requiredInputs',
      'supportedFormats',
      'supportedLayouts',
      'unavailableReason',
    ],
    disallowNullValues: const ['isAvailable', 'isNetworkBacked', 'kind'],
  );
  return DataSourceOutput(
    displayName: !json.containsKey('displayName')
        ? null
        : DataSourceOutput._read_displayName(json['displayName']),
    isAvailable: json['isAvailable'] as bool?,
    isNetworkBacked: json['isNetworkBacked'] as bool?,
    kind: DataSourceOutput._read_kind(json['kind']),
    name: !json.containsKey('name')
        ? null
        : DataSourceOutput._read_name(json['name']),
    requiredInputs: !json.containsKey('requiredInputs')
        ? null
        : DataSourceOutput._read_requiredInputs(json['requiredInputs']),
    supportedFormats: !json.containsKey('supportedFormats')
        ? null
        : DataSourceOutput._read_supportedFormats(json['supportedFormats']),
    supportedLayouts: !json.containsKey('supportedLayouts')
        ? null
        : DataSourceOutput._read_supportedLayouts(json['supportedLayouts']),
    unavailableReason: !json.containsKey('unavailableReason')
        ? null
        : DataSourceOutput._read_unavailableReason(json['unavailableReason']),
  );
}

Map<String, dynamic> _$DataSourceOutputToJson(DataSourceOutput instance) =>
    <String, dynamic>{
      if (instance.displayName case final $value?)
        'displayName': DataSourceOutput._write_displayName($value),
      'isAvailable': ?instance.isAvailable,
      'isNetworkBacked': ?instance.isNetworkBacked,
      'kind': ?DataSourceOutput._write_kind(instance.kind),
      if (instance.name case final $value?)
        'name': DataSourceOutput._write_name($value),
      if (instance.requiredInputs case final $value?)
        'requiredInputs': DataSourceOutput._write_requiredInputs($value),
      if (instance.supportedFormats case final $value?)
        'supportedFormats': DataSourceOutput._write_supportedFormats($value),
      if (instance.supportedLayouts case final $value?)
        'supportedLayouts': DataSourceOutput._write_supportedLayouts($value),
      if (instance.unavailableReason case final $value?)
        'unavailableReason': DataSourceOutput._write_unavailableReason($value),
    };
