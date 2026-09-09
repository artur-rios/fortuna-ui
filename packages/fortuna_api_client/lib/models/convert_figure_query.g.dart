// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQuery _$ConvertFigureQueryFromJson(Map<String, dynamic> json) =>
    ConvertFigureQuery(
      amounts: (json['amounts'] as List<dynamic>?)
          ?.map((e) => FigureAmountInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      displayCurrencyCode: json['displayCurrencyCode'] as String?,
      figureDate: json['figureDate'] == null
          ? null
          : DateTime.parse(json['figureDate'] as String),
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConvertFigureQueryToJson(ConvertFigureQuery instance) =>
    <String, dynamic>{
      'amounts': instance.amounts,
      'displayCurrencyCode': instance.displayCurrencyCode,
      'figureDate': instance.figureDate?.toIso8601String(),
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };
