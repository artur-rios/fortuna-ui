// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQuery _$ConvertFigureQueryFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amounts',
      'displayCurrencyCode',
      'figureDate',
      'pageNumber',
      'pageSize',
    ],
    disallowNullValues: const ['figureDate', 'pageNumber', 'pageSize'],
  );
  return ConvertFigureQuery(
    amounts: !json.containsKey('amounts')
        ? null
        : ConvertFigureQuery._read_amounts(json['amounts']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : ConvertFigureQuery._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    figureDate: json['figureDate'] as String?,
    pageNumber: ConvertFigureQuery._read_pageNumber(json['pageNumber']),
    pageSize: ConvertFigureQuery._read_pageSize(json['pageSize']),
  );
}

Map<String, dynamic> _$ConvertFigureQueryToJson(ConvertFigureQuery instance) =>
    <String, dynamic>{
      if (instance.amounts case final $value?)
        'amounts': ConvertFigureQuery._write_amounts($value),
      if (instance.displayCurrencyCode case final $value?)
        'displayCurrencyCode': ConvertFigureQuery._write_displayCurrencyCode(
          $value,
        ),
      'figureDate': ?instance.figureDate,
      'pageNumber': ?ConvertFigureQuery._write_pageNumber(instance.pageNumber),
      'pageSize': ?ConvertFigureQuery._write_pageSize(instance.pageSize),
    };
