// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_lifecycle_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardLifecycleCommandOutputDataOutput$Response
_$CreditCardLifecycleCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CreditCardLifecycleCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreditCardLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp:
        CreditCardLifecycleCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CreditCardLifecycleCommandOutputDataOutput$ResponseToJson(
  CreditCardLifecycleCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?CreditCardLifecycleCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
