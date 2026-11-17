// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_export_query_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataExportQueryOutputDataOutput$Request
_$PersonalDataExportQueryOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return PersonalDataExportQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : PersonalDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : PersonalDataExportQueryOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : PersonalDataExportQueryOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: PersonalDataExportQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$PersonalDataExportQueryOutputDataOutput$RequestToJson(
  PersonalDataExportQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': PersonalDataExportQueryOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': PersonalDataExportQueryOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?PersonalDataExportQueryOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
