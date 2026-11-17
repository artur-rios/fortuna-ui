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
    disallowNullValues: const ['timestamp'],
  );
  return TransactionDrillDownOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : TransactionDrillDownOutput$Request.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: TransactionDrillDownOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransactionDrillDownOutputDataOutput$RequestToJson(
  TransactionDrillDownOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?TransactionDrillDownOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
