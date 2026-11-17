// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceListOutput _$DataSourceListOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['sources']);
  return DataSourceListOutput(
    sources: !json.containsKey('sources')
        ? null
        : DataSourceListOutput._read_sources(json['sources']),
  );
}

Map<String, dynamic> _$DataSourceListOutputToJson(
  DataSourceListOutput instance,
) => <String, dynamic>{
  if (instance.sources case final $value?)
    'sources': DataSourceListOutput._write_sources($value),
};
