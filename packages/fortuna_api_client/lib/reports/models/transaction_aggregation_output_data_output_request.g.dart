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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionAggregationOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionAggregationOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionAggregationOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionAggregationOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: TransactionAggregationOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionAggregationOutputDataOutput$RequestToJson(
  TransactionAggregationOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionAggregationOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': TransactionAggregationOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?TransactionAggregationOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
