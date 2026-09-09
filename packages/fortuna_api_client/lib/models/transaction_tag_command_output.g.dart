// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tag_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTagCommandOutput _$TransactionTagCommandOutputFromJson(
  Map<String, dynamic> json,
) => TransactionTagCommandOutput(
  id: json['id'] as String?,
  isAttached: json['isAttached'] as bool?,
  tagCount: (json['tagCount'] as num?)?.toInt(),
  tagId: json['tagId'] as String?,
);

Map<String, dynamic> _$TransactionTagCommandOutputToJson(
  TransactionTagCommandOutput instance,
) => <String, dynamic>{
  'id': instance.id,
  'isAttached': instance.isAttached,
  'tagCount': instance.tagCount,
  'tagId': instance.tagId,
};
