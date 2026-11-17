// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommandOutputDataOutput$Response
_$UpdateFinancialAccountCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return UpdateFinancialAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UpdateFinancialAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateFinancialAccountCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateFinancialAccountCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        UpdateFinancialAccountCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$UpdateFinancialAccountCommandOutputDataOutput$ResponseToJson(
  UpdateFinancialAccountCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        UpdateFinancialAccountCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        UpdateFinancialAccountCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?UpdateFinancialAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
