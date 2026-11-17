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
    disallowNullValues: const [
      'id',
      'isIncluded',
      'rateSource',
      'resourceType',
    ],
  );
  return GoalResourceProgressOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : GoalResourceProgressOutput._read_appliedRate(json['appliedRate']),
    convertedAmount: !json.containsKey('convertedAmount')
        ? null
        : GoalResourceProgressOutput._read_convertedAmount(
            json['convertedAmount'],
          ),
    exclusionReason: !json.containsKey('exclusionReason')
        ? null
        : GoalResourceProgressOutput._read_exclusionReason(
            json['exclusionReason'],
          ),
    id: json['id'] as String?,
    isIncluded: json['isIncluded'] as bool?,
    name: !json.containsKey('name')
        ? null
        : GoalResourceProgressOutput._read_name(json['name']),
    rateDate: !json.containsKey('rateDate')
        ? null
        : GoalResourceProgressOutput._read_rateDate(json['rateDate']),
    rateSource: GoalResourceProgressOutput._read_rateSource(json['rateSource']),
    resourceType: GoalResourceProgressOutput._read_resourceType(
      json['resourceType'],
    ),
    sourceAmount: !json.containsKey('sourceAmount')
        ? null
        : GoalResourceProgressOutput._read_sourceAmount(json['sourceAmount']),
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : GoalResourceProgressOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : GoalResourceProgressOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$GoalResourceProgressOutputToJson(
  GoalResourceProgressOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': GoalResourceProgressOutput._write_appliedRate($value),
  if (instance.convertedAmount case final $value?)
    'convertedAmount': GoalResourceProgressOutput._write_convertedAmount(
      $value,
    ),
  if (instance.exclusionReason case final $value?)
    'exclusionReason': GoalResourceProgressOutput._write_exclusionReason(
      $value,
    ),
  'id': ?instance.id,
  'isIncluded': ?instance.isIncluded,
  if (instance.name case final $value?)
    'name': GoalResourceProgressOutput._write_name($value),
  if (instance.rateDate case final $value?)
    'rateDate': GoalResourceProgressOutput._write_rateDate($value),
  'rateSource': ?GoalResourceProgressOutput._write_rateSource(
    instance.rateSource,
  ),
  'resourceType': ?GoalResourceProgressOutput._write_resourceType(
    instance.resourceType,
  ),
  if (instance.sourceAmount case final $value?)
    'sourceAmount': GoalResourceProgressOutput._write_sourceAmount($value),
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode': GoalResourceProgressOutput._write_sourceCurrencyCode(
      $value,
    ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': GoalResourceProgressOutput._write_unconvertedReason(
      $value,
    ),
};
