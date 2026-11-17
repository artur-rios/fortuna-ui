// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationListOutputDataOutput$Request
_$CommittedObligationListOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CommittedObligationListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CommittedObligationListOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CommittedObligationListOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CommittedObligationListOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CommittedObligationListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CommittedObligationListOutputDataOutput$RequestToJson(
  CommittedObligationListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CommittedObligationListOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': CommittedObligationListOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?CommittedObligationListOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
