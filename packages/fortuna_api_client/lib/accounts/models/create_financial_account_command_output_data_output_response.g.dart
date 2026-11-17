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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CreateFinancialAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreateFinancialAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateFinancialAccountCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateFinancialAccountCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        CreateFinancialAccountCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        CreateFinancialAccountCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?CreateFinancialAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
