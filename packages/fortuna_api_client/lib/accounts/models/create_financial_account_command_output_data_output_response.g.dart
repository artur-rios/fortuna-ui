// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommandOutputDataOutput$Response
_$CreateFinancialAccountCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CreateFinancialAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreateFinancialAccountCommandOutput.fromJson(
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
        CreateFinancialAccountCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CreateFinancialAccountCommandOutputDataOutput$ResponseToJson(
  CreateFinancialAccountCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?CreateFinancialAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
