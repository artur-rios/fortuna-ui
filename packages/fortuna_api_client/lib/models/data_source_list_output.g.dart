// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceListOutput _$DataSourceListOutputFromJson(
  Map<String, dynamic> json,
) => DataSourceListOutput(
  sources: (json['sources'] as List<dynamic>?)
      ?.map((e) => DataSourceOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataSourceListOutputToJson(
  DataSourceListOutput instance,
) => <String, dynamic>{'sources': instance.sources};
