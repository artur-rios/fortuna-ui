// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_projection_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowProjectionOutputDataOutput$Response
_$CashFlowProjectionOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CashFlowProjectionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CashFlowProjectionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CashFlowProjectionOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CashFlowProjectionOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: CashFlowProjectionOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CashFlowProjectionOutputDataOutput$ResponseToJson(
  CashFlowProjectionOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CashFlowProjectionOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CashFlowProjectionOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?CashFlowProjectionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
