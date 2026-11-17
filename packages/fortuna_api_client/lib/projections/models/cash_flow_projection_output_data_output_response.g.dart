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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return CashFlowProjectionOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CashFlowProjectionOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?CashFlowProjectionOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
