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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateInvestmentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateInvestmentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateInvestmentCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateInvestmentCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: UpdateInvestmentCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateInvestmentCommandOutputDataOutput$RequestToJson(
  UpdateInvestmentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateInvestmentCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': UpdateInvestmentCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?UpdateInvestmentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
