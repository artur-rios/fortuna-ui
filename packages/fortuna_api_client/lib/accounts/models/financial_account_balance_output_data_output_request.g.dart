// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_balance_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountBalanceOutputDataOutput$Request
_$FinancialAccountBalanceOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return FinancialAccountBalanceOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : FinancialAccountBalanceOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountBalanceOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountBalanceOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: FinancialAccountBalanceOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountBalanceOutputDataOutput$RequestToJson(
  FinancialAccountBalanceOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': FinancialAccountBalanceOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': FinancialAccountBalanceOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?FinancialAccountBalanceOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
