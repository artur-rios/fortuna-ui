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
    displayName: json['displayName'] as String?,
    isAvailable: json['isAvailable'] as bool?,
    isNetworkBacked: json['isNetworkBacked'] as bool?,
    kind: DataSourceOutput._read_kind(json['kind']),
    name: json['name'] as String?,
    requiredInputs: (json['requiredInputs'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    supportedFormats: (json['supportedFormats'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    supportedLayouts: (json['supportedLayouts'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    unavailableReason: json['unavailableReason'] as String?,
  );
}

Map<String, dynamic> _$DataSourceOutputToJson(DataSourceOutput instance) =>
    <String, dynamic>{
      'displayName': ?instance.displayName,
      'isAvailable': ?instance.isAvailable,
      'isNetworkBacked': ?instance.isNetworkBacked,
      'kind': ?DataSourceOutput._write_kind(instance.kind),
      'name': ?instance.name,
      'requiredInputs': ?instance.requiredInputs,
      'supportedFormats': ?instance.supportedFormats,
      'supportedLayouts': ?instance.supportedLayouts,
      'unavailableReason': ?instance.unavailableReason,
    };
