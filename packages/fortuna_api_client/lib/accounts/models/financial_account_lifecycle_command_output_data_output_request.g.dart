// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountLifecycleCommandOutputDataOutput$Request
_$FinancialAccountLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return FinancialAccountLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : FinancialAccountLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        FinancialAccountLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$FinancialAccountLifecycleCommandOutputDataOutput$RequestToJson(
  FinancialAccountLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        FinancialAccountLifecycleCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        FinancialAccountLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?FinancialAccountLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
