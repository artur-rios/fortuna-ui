// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_imports_excel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiImportsExcelRequest _$PostApiImportsExcelRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    disallowNullValues: const [
      'AmountColumn',
      'CategoryColumn',
      'CreateMissingCategories',
      'DateColumn',
      'DescriptionColumn',
      'DirectionColumn',
      'ExternalIdColumn',
      'File',
      'TargetId',
      'TargetType',
    ],
  );
  return PostApiImportsExcelRequest(
    amountColumn: json['AmountColumn'] as String?,
    categoryColumn: json['CategoryColumn'] as String?,
    createMissingCategories: json['CreateMissingCategories'] as bool?,
    dateColumn: json['DateColumn'] as String?,
    descriptionColumn: json['DescriptionColumn'] as String?,
    directionColumn: json['DirectionColumn'] as String?,
    externalIdColumn: json['ExternalIdColumn'] as String?,
    file: json['File'] as String?,
    targetId: json['TargetId'] as String?,
    targetType: PostApiImportsExcelRequest._read_targetType(json['TargetType']),
    additionalProperties:
        PostApiImportsExcelRequest._extras(json, 'additionalProperties') == null
        ? const {}
        : PostApiImportsExcelRequest._readExtras(
            PostApiImportsExcelRequest._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PostApiImportsExcelRequestToJson(
  PostApiImportsExcelRequest instance,
) => <String, dynamic>{
  'AmountColumn': ?instance.amountColumn,
  'CategoryColumn': ?instance.categoryColumn,
  'CreateMissingCategories': ?instance.createMissingCategories,
  'DateColumn': ?instance.dateColumn,
  'DescriptionColumn': ?instance.descriptionColumn,
  'DirectionColumn': ?instance.directionColumn,
  'ExternalIdColumn': ?instance.externalIdColumn,
  'File': ?instance.file,
  'TargetId': ?instance.targetId,
  'TargetType': ?PostApiImportsExcelRequest._write_targetType(
    instance.targetType,
  ),
};
