// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_category_transactions_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignCategoryTransactionsCommandOutputDataOutput$Request
_$ReassignCategoryTransactionsCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return ReassignCategoryTransactionsCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ReassignCategoryTransactionsCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        ReassignCategoryTransactionsCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReassignCategoryTransactionsCommandOutputDataOutput$RequestToJson(
  ReassignCategoryTransactionsCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ReassignCategoryTransactionsCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
