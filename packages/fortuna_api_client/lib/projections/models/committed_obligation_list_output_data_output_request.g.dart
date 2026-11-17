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
    disallowNullValues: const ['timestamp'],
  );
  return CommittedObligationListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CommittedObligationListOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: CommittedObligationListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CommittedObligationListOutputDataOutput$RequestToJson(
  CommittedObligationListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?CommittedObligationListOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
