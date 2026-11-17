// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommandOutputDataOutput$Request
_$CreateCreditCardCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return CreateCreditCardCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CreateCreditCardCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCreditCardCommandOutputDataOutput$RequestToJson(
  CreateCreditCardCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CreateCreditCardCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
