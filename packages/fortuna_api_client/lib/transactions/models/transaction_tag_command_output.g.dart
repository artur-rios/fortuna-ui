// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tag_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTagCommandOutput _$TransactionTagCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'isAttached', 'tagCount', 'tagId'],
    disallowNullValues: const ['id', 'isAttached', 'tagCount', 'tagId'],
  );
  return TransactionTagCommandOutput(
    id: json['id'] as String?,
    isAttached: json['isAttached'] as bool?,
    tagCount: TransactionTagCommandOutput._read_tagCount(json['tagCount']),
    tagId: json['tagId'] as String?,
  );
}

Map<String, dynamic> _$TransactionTagCommandOutputToJson(
  TransactionTagCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'isAttached': ?instance.isAttached,
  'tagCount': ?TransactionTagCommandOutput._write_tagCount(instance.tagCount),
  'tagId': ?instance.tagId,
};
