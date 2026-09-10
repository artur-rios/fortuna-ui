// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommandOutput _$EraseUserCommandOutputFromJson(
  Map<String, dynamic> json,
) => EraseUserCommandOutput(
  erased: (json['erased'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  irreversible: json['irreversible'] as bool?,
  revokedConnections: (json['revokedConnections'] as num?)?.toInt(),
);

Map<String, dynamic> _$EraseUserCommandOutputToJson(
  EraseUserCommandOutput instance,
) => <String, dynamic>{
  'erased': instance.erased,
  'irreversible': instance.irreversible,
  'revokedConnections': instance.revokedConnections,
};
