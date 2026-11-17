// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_list_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagListOutput$Response _$TagListOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'pageNumber',
      'pageSize',
      'tags',
      'totalItems',
      'totalPages',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
  );
  return TagListOutput$Response(
    pageNumber: TagListOutput$Response._read_pageNumber(json['pageNumber']),
    pageSize: TagListOutput$Response._read_pageSize(json['pageSize']),
    tags: !json.containsKey('tags')
        ? null
        : TagListOutput$Response._read_tags(json['tags']),
    totalItems: TagListOutput$Response._read_totalItems(json['totalItems']),
    totalPages: TagListOutput$Response._read_totalPages(json['totalPages']),
  );
}

Map<String, dynamic> _$TagListOutput$ResponseToJson(
  TagListOutput$Response instance,
) => <String, dynamic>{
  'pageNumber': ?TagListOutput$Response._write_pageNumber(instance.pageNumber),
  'pageSize': ?TagListOutput$Response._write_pageSize(instance.pageSize),
  if (instance.tags case final $value?)
    'tags': TagListOutput$Response._write_tags($value),
  'totalItems': ?TagListOutput$Response._write_totalItems(instance.totalItems),
  'totalPages': ?TagListOutput$Response._write_totalPages(instance.totalPages),
};
