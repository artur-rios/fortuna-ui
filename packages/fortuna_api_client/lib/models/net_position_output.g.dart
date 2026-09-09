// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_position_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetPositionOutput _$NetPositionOutputFromJson(Map<String, dynamic> json) =>
    NetPositionOutput(
      asOf: json['asOf'] == null
          ? null
          : DateTime.parse(json['asOf'] as String),
      currencyGroups: (json['currencyGroups'] as List<dynamic>?)
          ?.map(
            (e) =>
                NetPositionCurrencyOutput.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      displayCurrencyCode: json['displayCurrencyCode'] as String?,
      isFullyConverted: json['isFullyConverted'] as bool?,
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NetPositionOutputToJson(NetPositionOutput instance) =>
    <String, dynamic>{
      'asOf': instance.asOf?.toIso8601String(),
      'currencyGroups': instance.currencyGroups,
      'displayCurrencyCode': instance.displayCurrencyCode,
      'isFullyConverted': instance.isFullyConverted,
      'total': instance.total,
    };
