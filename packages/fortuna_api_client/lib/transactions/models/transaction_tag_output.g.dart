// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tag_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTagOutput _$TransactionTagOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return TransactionTagOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : TransactionTagOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$TransactionTagOutputToJson(
  TransactionTagOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': TransactionTagOutput._write_name($value),
};
