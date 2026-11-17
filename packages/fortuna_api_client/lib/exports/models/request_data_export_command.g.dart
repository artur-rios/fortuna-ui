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
    columns: !json.containsKey('columns')
        ? null
        : RequestDataExportCommand._read_columns(json['columns']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : RequestDataExportCommand._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    filters: !json.containsKey('filters')
        ? null
        : RequestDataExportCommand._read_filters(json['filters']),
    format: !json.containsKey('format')
        ? null
        : RequestDataExportCommand._read_format(json['format']),
    locale: !json.containsKey('locale')
        ? null
        : RequestDataExportCommand._read_locale(json['locale']),
    recordSet: !json.containsKey('recordSet')
        ? null
        : RequestDataExportCommand._read_recordSet(json['recordSet']),
    sorts: !json.containsKey('sorts')
        ? null
        : RequestDataExportCommand._read_sorts(json['sorts']),
  );
}

Map<String, dynamic> _$RequestDataExportCommandToJson(
  RequestDataExportCommand instance,
) => <String, dynamic>{
  if (instance.columns case final $value?)
    'columns': RequestDataExportCommand._write_columns($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': RequestDataExportCommand._write_displayCurrencyCode(
      $value,
    ),
  if (instance.filters case final $value?)
    'filters': RequestDataExportCommand._write_filters($value),
  if (instance.format case final $value?)
    'format': RequestDataExportCommand._write_format($value),
  if (instance.locale case final $value?)
    'locale': RequestDataExportCommand._write_locale($value),
  if (instance.recordSet case final $value?)
    'recordSet': RequestDataExportCommand._write_recordSet($value),
  if (instance.sorts case final $value?)
    'sorts': RequestDataExportCommand._write_sorts($value),
};
