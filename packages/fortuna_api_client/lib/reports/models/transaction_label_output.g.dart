// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_label_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionLabelOutput _$TransactionLabelOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return TransactionLabelOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : TransactionLabelOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$TransactionLabelOutputToJson(
  TransactionLabelOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  if (instance.name case final $value?)
    'name': TransactionLabelOutput._write_name($value),
};
