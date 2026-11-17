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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ReassignCategoryTransactionsCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ReassignCategoryTransactionsCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ReassignCategoryTransactionsCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ReassignCategoryTransactionsCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        ReassignCategoryTransactionsCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ReassignCategoryTransactionsCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ReassignCategoryTransactionsCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
