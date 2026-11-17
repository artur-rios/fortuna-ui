// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_excel_workbook_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportExcelWorkbookCommandOutput _$ImportExcelWorkbookCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['importJobId', 'status'],
    disallowNullValues: const ['importJobId', 'status'],
  );
  return ImportExcelWorkbookCommandOutput(
    importJobId: json['importJobId'] as String?,
    status: ImportExcelWorkbookCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$ImportExcelWorkbookCommandOutputToJson(
  ImportExcelWorkbookCommandOutput instance,
) => <String, dynamic>{
  'importJobId': ?instance.importJobId,
  'status': ?ImportExcelWorkbookCommandOutput._write_status(instance.status),
};
