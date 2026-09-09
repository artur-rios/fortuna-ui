// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauthenticate_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReauthenticateConnectionCommandOutput
_$ReauthenticateConnectionCommandOutputFromJson(Map<String, dynamic> json) =>
    ReauthenticateConnectionCommandOutput(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      dataSourceType: json['dataSourceType'] == null
          ? null
          : TransactionSourceType.fromJson(
              (json['dataSourceType'] as num).toInt(),
            ),
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

Map<String, dynamic> _$ReauthenticateConnectionCommandOutputToJson(
  ReauthenticateConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'dataSourceType': _$TransactionSourceTypeEnumMap[instance.dataSourceType],
  'externalReference': instance.externalReference,
  'id': instance.id,
  'institution': instance.institution,
  'status': _$ConnectionStatusEnumMap[instance.status],
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$TransactionSourceTypeEnumMap = {
  TransactionSourceType.value1: 1,
  TransactionSourceType.value2: 2,
  TransactionSourceType.value3: 3,
  TransactionSourceType.value4: 4,
  TransactionSourceType.$unknown: r'$unknown',
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.value1: 1,
  ConnectionStatus.value2: 2,
  ConnectionStatus.value3: 3,
  ConnectionStatus.$unknown: r'$unknown',
};
