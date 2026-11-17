// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_export_query_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataExportQueryOutputDataOutput$Response
_$PersonalDataExportQueryOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return PersonalDataExportQueryOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : PersonalDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : PersonalDataExportQueryOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : PersonalDataExportQueryOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: PersonalDataExportQueryOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$PersonalDataExportQueryOutputDataOutput$ResponseToJson(
  PersonalDataExportQueryOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': PersonalDataExportQueryOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        PersonalDataExportQueryOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?PersonalDataExportQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
