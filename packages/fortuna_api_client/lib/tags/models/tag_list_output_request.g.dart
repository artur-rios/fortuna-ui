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
    tags: !json.containsKey('tags')
        ? null
        : TagListOutput$Request._read_tags(json['tags']),
    totalItems: TagListOutput$Request._read_totalItems(json['totalItems']),
  );
}

Map<String, dynamic> _$TagListOutput$RequestToJson(
  TagListOutput$Request instance,
) => <String, dynamic>{
  'pageNumber': ?TagListOutput$Request._write_pageNumber(instance.pageNumber),
  'pageSize': ?TagListOutput$Request._write_pageSize(instance.pageSize),
  if (instance.tags case final $value?)
    'tags': TagListOutput$Request._write_tags($value),
  'totalItems': ?TagListOutput$Request._write_totalItems(instance.totalItems),
};
