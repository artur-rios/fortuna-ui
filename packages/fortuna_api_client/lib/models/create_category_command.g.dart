// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryCommand _$CreateCategoryCommandFromJson(
  Map<String, dynamic> json,
) => CreateCategoryCommand(
  name: json['name'] as String?,
  parentId: json['parentId'] as String?,
);

Map<String, dynamic> _$CreateCategoryCommandToJson(
  CreateCategoryCommand instance,
) => <String, dynamic>{'name': instance.name, 'parentId': instance.parentId};
