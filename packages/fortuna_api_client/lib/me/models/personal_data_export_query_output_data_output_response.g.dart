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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return PersonalDataExportQueryOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?PersonalDataExportQueryOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
