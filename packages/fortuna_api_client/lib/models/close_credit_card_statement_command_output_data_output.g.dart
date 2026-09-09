// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_credit_card_statement_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseCreditCardStatementCommandOutputDataOutput
_$CloseCreditCardStatementCommandOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => CloseCreditCardStatementCommandOutputDataOutput(
  data: json['data'] == null
      ? null
      : CloseCreditCardStatementCommandOutput.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$CloseCreditCardStatementCommandOutputDataOutputToJson(
  CloseCreditCardStatementCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
