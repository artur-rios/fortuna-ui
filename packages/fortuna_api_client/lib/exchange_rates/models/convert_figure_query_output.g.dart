// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQueryOutput _$ConvertFigureQueryOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'displayCurrencyCode',
      'figureDate',
      'groups',
      'isFullyConverted',
      'missingRates',
      'total',
    ],
    disallowNullValues: const ['figureDate', 'isFullyConverted'],
  );
  return ConvertFigureQueryOutput(
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : ConvertFigureQueryOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    figureDate: json['figureDate'] as String?,
    groups: !json.containsKey('groups')
        ? null
        : ConvertFigureQueryOutput._read_groups(json['groups']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : ConvertFigureQueryOutput._read_missingRates(json['missingRates']),
    total: !json.containsKey('total')
        ? null
        : ConvertFigureQueryOutput._read_total(json['total']),
  );
}

Map<String, dynamic> _$ConvertFigureQueryOutputToJson(
  ConvertFigureQueryOutput instance,
) => <String, dynamic>{
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode': ConvertFigureQueryOutput._write_displayCurrencyCode(
      $value,
    ),
  'figureDate': ?instance.figureDate,
  if (instance.groups case final $value?)
    'groups': ConvertFigureQueryOutput._write_groups($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': ConvertFigureQueryOutput._write_missingRates($value),
  if (instance.total case final $value?)
    'total': ConvertFigureQueryOutput._write_total($value),
};
