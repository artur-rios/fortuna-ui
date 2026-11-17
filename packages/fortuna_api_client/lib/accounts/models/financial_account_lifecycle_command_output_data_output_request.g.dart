// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountLifecycleCommandOutputDataOutput$Request
_$FinancialAccountLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return FinancialAccountLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : FinancialAccountLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        FinancialAccountLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$FinancialAccountLifecycleCommandOutputDataOutput$RequestToJson(
  FinancialAccountLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?FinancialAccountLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
