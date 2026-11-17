// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommandOutputDataOutput$Request
_$CreateFinancialAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreateFinancialAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateFinancialAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateFinancialAccountCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateFinancialAccountCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        CreateFinancialAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$CreateFinancialAccountCommandOutputDataOutput$RequestToJson(
  CreateFinancialAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        CreateFinancialAccountCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        CreateFinancialAccountCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CreateFinancialAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
