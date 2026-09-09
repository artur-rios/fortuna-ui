// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutput _$TagListOutputFromJson(Map<String, dynamic> json) =>
    TagListOutput(
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TagListOutputToJson(TagListOutput instance) =>
    <String, dynamic>{'tags': instance.tags};
