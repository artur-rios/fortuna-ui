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
    disallowNullValues: const ['success', 'timestamp'],
  );
  return ReassignCategoryTransactionsCommandOutputDataOutput$Response(
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?ReassignCategoryTransactionsCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
