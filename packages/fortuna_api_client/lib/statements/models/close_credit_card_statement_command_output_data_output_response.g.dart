// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_credit_card_statement_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseCreditCardStatementCommandOutputDataOutput$Response
_$CloseCreditCardStatementCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CloseCreditCardStatementCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CloseCreditCardStatementCommandOutput.fromJson(
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
        CloseCreditCardStatementCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CloseCreditCardStatementCommandOutputDataOutput$ResponseToJson(
  CloseCreditCardStatementCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?CloseCreditCardStatementCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
