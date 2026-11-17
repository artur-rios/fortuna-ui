// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommandOutputDataOutput$Request
_$UpdateFinancialAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return UpdateFinancialAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateFinancialAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        UpdateFinancialAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$UpdateFinancialAccountCommandOutputDataOutput$RequestToJson(
  UpdateFinancialAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?UpdateFinancialAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
