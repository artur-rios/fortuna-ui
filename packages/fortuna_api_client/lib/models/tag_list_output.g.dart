// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutput _$TagListOutputFromJson(Map<String, dynamic> json) =>
    TagListOutput(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TagListOutputToJson(TagListOutput instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'tags': instance.tags,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
    };
