// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_connection_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevokeConnectionCommandOutput _$RevokeConnectionCommandOutputFromJson(
  Map<String, dynamic> json,
) => RevokeConnectionCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  dataSourceType: json['dataSourceType'] == null
      ? null
      : TransactionSourceType.fromJson((json['dataSourceType'] as num).toInt()),
  externalReference: json['externalReference'] as String?,
  id: json['id'] as String?,
  importedDataRetained: json['importedDataRetained'] as bool?,
  status: json['status'] == null
      ? null
      : ConnectionStatus.fromJson((json['status'] as num).toInt()),
  stoppedSynchronizations: (json['stoppedSynchronizations'] as num?)?.toInt(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RevokeConnectionCommandOutputToJson(
  RevokeConnectionCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'dataSourceType': _$TransactionSourceTypeEnumMap[instance.dataSourceType],
  'externalReference': instance.externalReference,
  'id': instance.id,
  'importedDataRetained': instance.importedDataRetained,
  'status': _$ConnectionStatusEnumMap[instance.status],
  'stoppedSynchronizations': instance.stoppedSynchronizations,
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
