// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_resource_progress_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResourceProgressOutput _$GoalResourceProgressOutputFromJson(
  Map<String, dynamic> json,
) => GoalResourceProgressOutput(
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  convertedAmount: (json['convertedAmount'] as num?)?.toDouble(),
  exclusionReason: json['exclusionReason'] as String?,
  id: json['id'] as String?,
  isIncluded: json['isIncluded'] as bool?,
  name: json['name'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  resourceType: json['resourceType'] == null
      ? null
      : GoalResourceType.fromJson((json['resourceType'] as num).toInt()),
  sourceAmount: (json['sourceAmount'] as num?)?.toDouble(),
  sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$GoalResourceProgressOutputToJson(
  GoalResourceProgressOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'convertedAmount': instance.convertedAmount,
  'exclusionReason': instance.exclusionReason,
  'id': instance.id,
  'isIncluded': instance.isIncluded,
  'name': instance.name,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': instance.rateSource,
  'resourceType': instance.resourceType,
  'sourceAmount': instance.sourceAmount,
  'sourceCurrencyCode': instance.sourceCurrencyCode,
  'unconvertedReason': instance.unconvertedReason,
};
