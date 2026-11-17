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
    disallowNullValues: const ['timestamp'],
  );
  return PersonalDataExportQueryOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : PersonalDataExportQueryOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: PersonalDataExportQueryOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$PersonalDataExportQueryOutputDataOutput$RequestToJson(
  PersonalDataExportQueryOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?PersonalDataExportQueryOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
