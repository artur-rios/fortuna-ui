// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_export_query_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataExportQueryOutputDataOutput
_$PersonalDataExportQueryOutputDataOutputFromJson(Map<String, dynamic> json) =>
    PersonalDataExportQueryOutputDataOutput(
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
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PersonalDataExportQueryOutputDataOutputToJson(
  PersonalDataExportQueryOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
