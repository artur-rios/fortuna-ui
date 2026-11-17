// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQueryOutputDataOutput$Request
_$ConvertFigureQueryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ConvertFigureQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ConvertFigureQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: ConvertFigureQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ConvertFigureQueryOutputDataOutput$RequestToJson(
  ConvertFigureQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?ConvertFigureQueryOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
