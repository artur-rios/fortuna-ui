// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutput$Request _$TagListOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['pageNumber', 'pageSize', 'tags', 'totalItems'],
    disallowNullValues: const ['pageNumber', 'pageSize', 'totalItems'],
  );
  return TagListOutput$Request(
    pageNumber: TagListOutput$Request._read_pageNumber(json['pageNumber']),
    pageSize: TagListOutput$Request._read_pageSize(json['pageSize']),
    tags: (json['tags'] as List<dynamic>?)
        ?.map((e) => TagOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalItems: TagListOutput$Request._read_totalItems(json['totalItems']),
  );
}

Map<String, dynamic> _$TagListOutput$RequestToJson(
  TagListOutput$Request instance,
) => <String, dynamic>{
  'pageNumber': ?TagListOutput$Request._write_pageNumber(instance.pageNumber),
  'pageSize': ?TagListOutput$Request._write_pageSize(instance.pageSize),
  'tags': ?instance.tags?.map((e) => e.toJson()).toList(),
  'totalItems': ?TagListOutput$Request._write_totalItems(instance.totalItems),
};
