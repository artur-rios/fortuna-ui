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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ConvertFigureQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ConvertFigureQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ConvertFigureQueryOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ConvertFigureQueryOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors': ConvertFigureQueryOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ConvertFigureQueryOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?ConvertFigureQueryOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
