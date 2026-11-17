// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_drill_down_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDrillDownOutputDataOutput$Request
_$TransactionDrillDownOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return TransactionDrillDownOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionDrillDownOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : TransactionDrillDownOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : TransactionDrillDownOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: TransactionDrillDownOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionDrillDownOutputDataOutput$RequestToJson(
  TransactionDrillDownOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransactionDrillDownOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': TransactionDrillDownOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?TransactionDrillDownOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
