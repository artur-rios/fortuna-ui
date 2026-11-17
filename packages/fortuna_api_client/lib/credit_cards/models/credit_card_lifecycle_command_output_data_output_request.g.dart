// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_lifecycle_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardLifecycleCommandOutputDataOutput$Request
_$CreditCardLifecycleCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreditCardLifecycleCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreditCardLifecycleCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardLifecycleCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardLifecycleCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        CreditCardLifecycleCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$CreditCardLifecycleCommandOutputDataOutput$RequestToJson(
  CreditCardLifecycleCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreditCardLifecycleCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CreditCardLifecycleCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?CreditCardLifecycleCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
