// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_total_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableTotalConversionOutput _$TableTotalConversionOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'convertedValue',
      'figureDate',
      'rateDate',
      'rateSource',
      'sourceCurrencyCode',
      'sourceValue',
      'unconvertedReason',
    ],
    disallowNullValues: const ['rateSource', 'sourceValue'],
  );
  return TableTotalConversionOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TableTotalConversionOutput._read_appliedRate(json['appliedRate']),
    convertedValue: !json.containsKey('convertedValue')
        ? null
        : TableTotalConversionOutput._read_convertedValue(
            json['convertedValue'],
          ),
    figureDate: !json.containsKey('figureDate')
        ? null
        : TableTotalConversionOutput._read_figureDate(json['figureDate']),
    rateDate: !json.containsKey('rateDate')
        ? null
        : TableTotalConversionOutput._read_rateDate(json['rateDate']),
    rateSource: TableTotalConversionOutput._read_rateSource(json['rateSource']),
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : TableTotalConversionOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    sourceValue: json['sourceValue'] as String?,
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : TableTotalConversionOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$TableTotalConversionOutputToJson(
  TableTotalConversionOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': TableTotalConversionOutput._write_appliedRate($value),
  if (instance.convertedValue case final $value?)
    'convertedValue': TableTotalConversionOutput._write_convertedValue($value),
  if (instance.figureDate case final $value?)
    'figureDate': TableTotalConversionOutput._write_figureDate($value),
  if (instance.rateDate case final $value?)
    'rateDate': TableTotalConversionOutput._write_rateDate($value),
  'rateSource': ?TableTotalConversionOutput._write_rateSource(
    instance.rateSource,
  ),
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode': TableTotalConversionOutput._write_sourceCurrencyCode(
      $value,
    ),
  'sourceValue': ?instance.sourceValue,
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': TableTotalConversionOutput._write_unconvertedReason(
      $value,
    ),
};
