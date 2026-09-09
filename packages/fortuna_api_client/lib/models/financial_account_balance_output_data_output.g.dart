// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_balance_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountBalanceOutputDataOutput
_$FinancialAccountBalanceOutputDataOutputFromJson(Map<String, dynamic> json) =>
    FinancialAccountBalanceOutputDataOutput(
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
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$FinancialAccountBalanceOutputDataOutputToJson(
  FinancialAccountBalanceOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
