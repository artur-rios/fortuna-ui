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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ConvertFigureQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ConvertFigureQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ConvertFigureQueryOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ConvertFigureQueryOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: ConvertFigureQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$ConvertFigureQueryOutputDataOutput$RequestToJson(
  ConvertFigureQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': ConvertFigureQueryOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ConvertFigureQueryOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?ConvertFigureQueryOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
