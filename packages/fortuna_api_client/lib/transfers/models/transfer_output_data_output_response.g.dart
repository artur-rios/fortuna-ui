// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferOutputDataOutput$Response _$TransferOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return TransferOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : TransferOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : TransferOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : TransferOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: TransferOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$TransferOutputDataOutput$ResponseToJson(
  TransferOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': TransferOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': TransferOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?TransferOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
