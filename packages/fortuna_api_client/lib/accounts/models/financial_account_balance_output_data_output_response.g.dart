// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_balance_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountBalanceOutputDataOutput$Response
_$FinancialAccountBalanceOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return FinancialAccountBalanceOutputDataOutput$Response(
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
    success: json['success'] as bool?,
    timestamp: FinancialAccountBalanceOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountBalanceOutputDataOutput$ResponseToJson(
  FinancialAccountBalanceOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?FinancialAccountBalanceOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
