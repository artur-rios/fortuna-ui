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
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    figureDate: json['figureDate'] as String?,
    groups: (json['groups'] as List<dynamic>?)
        ?.map(
          (e) =>
              ConvertedCurrencyGroupOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$ConvertFigureQueryOutputToJson(
  ConvertFigureQueryOutput instance,
) => <String, dynamic>{
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'figureDate': ?instance.figureDate,
  'groups': ?instance.groups?.map((e) => e.toJson()).toList(),
  'isFullyConverted': ?instance.isFullyConverted,
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
  'total': ?instance.total,
};
