// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_tag_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionTagOutput _$UpdateTransactionTagOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return UpdateTransactionTagOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : UpdateTransactionTagOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$UpdateTransactionTagOutputToJson(
  UpdateTransactionTagOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': UpdateTransactionTagOutput._write_name($value),
};
