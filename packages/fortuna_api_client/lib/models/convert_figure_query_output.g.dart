// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQueryOutput _$ConvertFigureQueryOutputFromJson(
  Map<String, dynamic> json,
) => ConvertFigureQueryOutput(
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  figureDate: json['figureDate'] == null
      ? null
      : DateTime.parse(json['figureDate'] as String),
  groups: (json['groups'] as List<dynamic>?)
      ?.map(
        (e) => ConvertedCurrencyGroupOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  isFullyConverted: json['isFullyConverted'] as bool?,
  total: json['total'] as String?,
);

Map<String, dynamic> _$ConvertFigureQueryOutputToJson(
  ConvertFigureQueryOutput instance,
) => <String, dynamic>{
  'displayCurrencyCode': instance.displayCurrencyCode,
  'figureDate': instance.figureDate?.toIso8601String(),
  'groups': instance.groups,
  'isFullyConverted': instance.isFullyConverted,
  'total': instance.total,
};
