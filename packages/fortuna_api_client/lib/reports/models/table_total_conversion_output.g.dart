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
    disallowNullValues: const ['sourceValue'],
  );
  return TableTotalConversionOutput(
    appliedRate: json['appliedRate'] as String?,
    convertedValue: json['convertedValue'] as String?,
    figureDate: json['figureDate'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: TableTotalConversionOutput._read_rateSource(json['rateSource']),
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    sourceValue: json['sourceValue'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$TableTotalConversionOutputToJson(
  TableTotalConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'convertedValue': ?instance.convertedValue,
  'figureDate': ?instance.figureDate,
  'rateDate': ?instance.rateDate,
  'rateSource': ?TableTotalConversionOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'sourceValue': ?instance.sourceValue,
  'unconvertedReason': ?instance.unconvertedReason,
};
