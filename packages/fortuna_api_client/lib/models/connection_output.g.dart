// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionOutput _$ConnectionOutputFromJson(Map<String, dynamic> json) =>
    ConnectionOutput(
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
      status: json['status'] == null
          ? null
          : ConnectionStatus.fromJson((json['status'] as num).toInt()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ConnectionOutputToJson(ConnectionOutput instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'dataSourceType': _$TransactionSourceTypeEnumMap[instance.dataSourceType],
      'externalReference': instance.externalReference,
      'id': instance.id,
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
