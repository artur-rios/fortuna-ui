// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_pdf_invoice_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportPdfInvoiceCommandOutput _$ImportPdfInvoiceCommandOutputFromJson(
  Map<String, dynamic> json,
) => ImportPdfInvoiceCommandOutput(
  importJobId: json['importJobId'] as String?,
  status: json['status'] == null
      ? null
      : ImportJobStatus.fromJson((json['status'] as num).toInt()),
);

Map<String, dynamic> _$ImportPdfInvoiceCommandOutputToJson(
  ImportPdfInvoiceCommandOutput instance,
) => <String, dynamic>{
  'importJobId': instance.importJobId,
  'status': _$ImportJobStatusEnumMap[instance.status],
};

const _$ImportJobStatusEnumMap = {
  ImportJobStatus.value1: 1,
  ImportJobStatus.value2: 2,
  ImportJobStatus.value3: 3,
  ImportJobStatus.value4: 4,
  ImportJobStatus.$unknown: r'$unknown',
};
