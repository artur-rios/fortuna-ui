// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommandOutputDataOutput$Response
_$CreateInvestmentCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CreateInvestmentCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreateInvestmentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateInvestmentCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateInvestmentCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: CreateInvestmentCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateInvestmentCommandOutputDataOutput$ResponseToJson(
  CreateInvestmentCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateInvestmentCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CreateInvestmentCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?CreateInvestmentCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
