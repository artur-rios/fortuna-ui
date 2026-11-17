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
    disallowNullValues: const ['timestamp'],
  );
  return FinancialAccountBalanceOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : FinancialAccountBalanceOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: FinancialAccountBalanceOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountBalanceOutputDataOutput$RequestToJson(
  FinancialAccountBalanceOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?FinancialAccountBalanceOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
