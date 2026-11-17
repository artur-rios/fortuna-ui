// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_investment_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInvestmentCommandOutputDataOutput$Request
_$UpdateInvestmentCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return UpdateInvestmentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateInvestmentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: UpdateInvestmentCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateInvestmentCommandOutputDataOutput$RequestToJson(
  UpdateInvestmentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?UpdateInvestmentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
