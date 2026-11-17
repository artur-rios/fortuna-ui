// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentLifecycleCommandOutputDataOutput$Request
_$InvestmentLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return InvestmentLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : InvestmentLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        InvestmentLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$InvestmentLifecycleCommandOutputDataOutput$RequestToJson(
  InvestmentLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?InvestmentLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
