// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_query_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentQueryOutput _$ProcessingConsentQueryOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['consents']);
  return ProcessingConsentQueryOutput(
    consents: !json.containsKey('consents')
        ? null
        : ProcessingConsentQueryOutput._read_consents(json['consents']),
  );
}

Map<String, dynamic> _$ProcessingConsentQueryOutputToJson(
  ProcessingConsentQueryOutput instance,
) => <String, dynamic>{
  if (instance.consents case final $value?)
    'consents': ProcessingConsentQueryOutput._write_consents($value),
};
