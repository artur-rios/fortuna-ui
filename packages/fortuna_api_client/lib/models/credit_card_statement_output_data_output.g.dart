// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputDataOutput
_$CreditCardStatementOutputDataOutputFromJson(Map<String, dynamic> json) =>
    CreditCardStatementOutputDataOutput(
      data: json['data'] == null
          ? null
          : CreditCardStatementOutput.fromJson(
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

Map<String, dynamic> _$CreditCardStatementOutputDataOutputToJson(
  CreditCardStatementOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
