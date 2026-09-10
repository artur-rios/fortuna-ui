// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentQueryOutput _$ProcessingConsentQueryOutputFromJson(
  Map<String, dynamic> json,
) => ProcessingConsentQueryOutput(
  consents: (json['consents'] as List<dynamic>?)
      ?.map(
        (e) => ProcessingConsentStateOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ProcessingConsentQueryOutputToJson(
  ProcessingConsentQueryOutput instance,
) => <String, dynamic>{'consents': instance.consents};
