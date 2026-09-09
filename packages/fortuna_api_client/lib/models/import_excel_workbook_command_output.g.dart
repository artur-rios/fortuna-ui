// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_excel_workbook_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportExcelWorkbookCommandOutput _$ImportExcelWorkbookCommandOutputFromJson(
  Map<String, dynamic> json,
) => ImportExcelWorkbookCommandOutput(
  importJobId: json['importJobId'] as String?,
  status: json['status'] == null
      ? null
      : ImportJobStatus.fromJson((json['status'] as num).toInt()),
);

Map<String, dynamic> _$ImportExcelWorkbookCommandOutputToJson(
  ImportExcelWorkbookCommandOutput instance,
) => <String, dynamic>{
  'importJobId': instance.importJobId,
  'status': instance.status,
};
