// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_data_export_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDataExportCommand _$RequestDataExportCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'columns',
      'displayCurrencyCode',
      'filters',
      'format',
      'locale',
      'recordSet',
      'sorts',
    ],
  );
  return RequestDataExportCommand(
    columns: (json['columns'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    filters: (json['filters'] as List<dynamic>?)
        ?.map((e) => DataExportFilterInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    format: json['format'] as String?,
    locale: json['locale'] as String?,
    recordSet: json['recordSet'] as String?,
    sorts: (json['sorts'] as List<dynamic>?)
        ?.map((e) => DataExportSortInput.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RequestDataExportCommandToJson(
  RequestDataExportCommand instance,
) => <String, dynamic>{
  'columns': ?instance.columns,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'filters': ?instance.filters?.map((e) => e.toJson()).toList(),
  'format': ?instance.format,
  'locale': ?instance.locale,
  'recordSet': ?instance.recordSet,
  'sorts': ?instance.sorts?.map((e) => e.toJson()).toList(),
};
