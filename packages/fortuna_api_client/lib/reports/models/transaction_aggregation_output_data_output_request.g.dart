// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationOutputDataOutput$Request
_$TransactionAggregationOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return TransactionAggregationOutputDataOutput$Request(
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
    timestamp: TransactionAggregationOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionAggregationOutputDataOutput$RequestToJson(
  TransactionAggregationOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?TransactionAggregationOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
