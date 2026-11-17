// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationOutputDataOutput$Response
_$TransactionAggregationOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return TransactionAggregationOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransactionAggregationOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: TransactionAggregationOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionAggregationOutputDataOutput$ResponseToJson(
  TransactionAggregationOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?TransactionAggregationOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
