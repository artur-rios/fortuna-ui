// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_investment_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvestmentCommandOutputDataOutput$Request
_$CreateInvestmentCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CreateInvestmentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateInvestmentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CreateInvestmentCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateInvestmentCommandOutputDataOutput$RequestToJson(
  CreateInvestmentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CreateInvestmentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
