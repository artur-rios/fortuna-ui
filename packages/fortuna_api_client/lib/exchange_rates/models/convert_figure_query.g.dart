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
    amounts: (json['amounts'] as List<dynamic>?)
        ?.map((e) => FigureAmountInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    figureDate: json['figureDate'] as String?,
    pageNumber: ConvertFigureQuery._read_pageNumber(json['pageNumber']),
    pageSize: ConvertFigureQuery._read_pageSize(json['pageSize']),
  );
}

Map<String, dynamic> _$ConvertFigureQueryToJson(ConvertFigureQuery instance) =>
    <String, dynamic>{
      'amounts': ?instance.amounts?.map((e) => e.toJson()).toList(),
      'displayCurrencyCode': ?instance.displayCurrencyCode,
      'figureDate': ?instance.figureDate,
      'pageNumber': ?ConvertFigureQuery._write_pageNumber(instance.pageNumber),
      'pageSize': ?ConvertFigureQuery._write_pageSize(instance.pageSize),
    };
