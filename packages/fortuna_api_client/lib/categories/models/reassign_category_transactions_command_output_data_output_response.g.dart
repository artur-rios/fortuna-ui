// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_category_transactions_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignCategoryTransactionsCommandOutputDataOutput$Response
_$ReassignCategoryTransactionsCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return ReassignCategoryTransactionsCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : ReassignCategoryTransactionsCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ReassignCategoryTransactionsCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ReassignCategoryTransactionsCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        ReassignCategoryTransactionsCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ReassignCategoryTransactionsCommandOutputDataOutput$ResponseToJson(
  ReassignCategoryTransactionsCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ReassignCategoryTransactionsCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ReassignCategoryTransactionsCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?ReassignCategoryTransactionsCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
