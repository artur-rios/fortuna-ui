// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommandOutput _$CreateConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) => CreateConnectionCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  dataSourceType: json['dataSourceType'] == null
      ? null
      : TransactionSourceType.fromJson((json['dataSourceType'] as num).toInt()),
  externalReference: json['externalReference'] as String?,
  id: json['id'] as String?,
  institution: json['institution'] as String?,
  status: json['status'] == null
      ? null
      : ConnectionStatus.fromJson((json['status'] as num).toInt()),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CreateConnectionCommandOutputToJson(
  CreateConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'dataSourceType': instance.dataSourceType,
  'externalReference': instance.externalReference,
  'id': instance.id,
  'institution': instance.institution,
  'status': instance.status,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
