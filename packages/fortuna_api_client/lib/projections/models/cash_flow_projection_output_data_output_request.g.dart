// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_projection_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowProjectionOutputDataOutput$Request
_$CashFlowProjectionOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CashFlowProjectionOutputDataOutput$Request(
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
    timestamp: CashFlowProjectionOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CashFlowProjectionOutputDataOutput$RequestToJson(
  CashFlowProjectionOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?CashFlowProjectionOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
