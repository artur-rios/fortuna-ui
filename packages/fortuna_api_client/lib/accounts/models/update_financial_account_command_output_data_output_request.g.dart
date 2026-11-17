// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommandOutputDataOutput$Request
_$UpdateFinancialAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateFinancialAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateFinancialAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateFinancialAccountCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateFinancialAccountCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        UpdateFinancialAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$UpdateFinancialAccountCommandOutputDataOutput$RequestToJson(
  UpdateFinancialAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        UpdateFinancialAccountCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        UpdateFinancialAccountCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?UpdateFinancialAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
