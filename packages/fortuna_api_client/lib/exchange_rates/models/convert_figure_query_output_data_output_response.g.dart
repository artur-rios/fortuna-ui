// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_figure_query_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConvertFigureQueryOutputDataOutput$Response
_$ConvertFigureQueryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ConvertFigureQueryOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp: ConvertFigureQueryOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ConvertFigureQueryOutputDataOutput$ResponseToJson(
  ConvertFigureQueryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?ConvertFigureQueryOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
