// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_resource_progress_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResourceProgressOutput _$GoalResourceProgressOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'convertedAmount',
      'exclusionReason',
      'id',
      'isIncluded',
      'name',
      'rateDate',
      'rateSource',
      'resourceType',
      'sourceAmount',
      'sourceCurrencyCode',
      'unconvertedReason',
    ],
    disallowNullValues: const ['id', 'isIncluded', 'resourceType'],
  );
  return GoalResourceProgressOutput(
    appliedRate: json['appliedRate'] as String?,
    convertedAmount: json['convertedAmount'] as String?,
    exclusionReason: json['exclusionReason'] as String?,
    id: json['id'] as String?,
    isIncluded: json['isIncluded'] as bool?,
    name: json['name'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: GoalResourceProgressOutput._read_rateSource(json['rateSource']),
    resourceType: GoalResourceProgressOutput._read_resourceType(
      json['resourceType'],
    ),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$GoalResourceProgressOutputToJson(
  GoalResourceProgressOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'convertedAmount': ?instance.convertedAmount,
  'exclusionReason': ?instance.exclusionReason,
  'id': ?instance.id,
  'isIncluded': ?instance.isIncluded,
  'name': ?instance.name,
  'rateDate': ?instance.rateDate,
  'rateSource': ?GoalResourceProgressOutput._write_rateSource(
    instance.rateSource,
  ),
  'resourceType': ?GoalResourceProgressOutput._write_resourceType(
    instance.resourceType,
  ),
  'sourceAmount': ?instance.sourceAmount,
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'unconvertedReason': ?instance.unconvertedReason,
};
