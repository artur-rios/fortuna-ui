// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationOutput _$CommittedObligationOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'currencyCode',
      'cycleEnd',
      'cycleStart',
      'daysOverdue',
      'displayAmount',
      'dueDate',
      'id',
      'isOverdue',
      'kind',
      'rateDate',
      'rateSource',
      'unconvertedReason',
    ],
    disallowNullValues: const [
      'amount',
      'daysOverdue',
      'dueDate',
      'id',
      'isOverdue',
      'kind',
      'rateSource',
    ],
  );
  return CommittedObligationOutput(
    amount: json['amount'] as String?,
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : CommittedObligationOutput._read_appliedRate(json['appliedRate']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CommittedObligationOutput._read_currencyCode(json['currencyCode']),
    cycleEnd: !json.containsKey('cycleEnd')
        ? null
        : CommittedObligationOutput._read_cycleEnd(json['cycleEnd']),
    cycleStart: !json.containsKey('cycleStart')
        ? null
        : CommittedObligationOutput._read_cycleStart(json['cycleStart']),
    daysOverdue: CommittedObligationOutput._read_daysOverdue(
      json['daysOverdue'],
    ),
    displayAmount: !json.containsKey('displayAmount')
        ? null
        : CommittedObligationOutput._read_displayAmount(json['displayAmount']),
    dueDate: json['dueDate'] as String?,
    id: json['id'] as String?,
    isOverdue: json['isOverdue'] as bool?,
    kind: CommittedObligationOutput._read_kind(json['kind']),
    rateDate: !json.containsKey('rateDate')
        ? null
        : CommittedObligationOutput._read_rateDate(json['rateDate']),
    rateSource: CommittedObligationOutput._read_rateSource(json['rateSource']),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : CommittedObligationOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$CommittedObligationOutputToJson(
  CommittedObligationOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': CommittedObligationOutput._write_appliedRate($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': CommittedObligationOutput._write_currencyCode($value),
  if (instance.cycleEnd case final $value?)
    'cycleEnd': CommittedObligationOutput._write_cycleEnd($value),
  if (instance.cycleStart case final $value?)
    'cycleStart': CommittedObligationOutput._write_cycleStart($value),
  'daysOverdue': ?CommittedObligationOutput._write_daysOverdue(
    instance.daysOverdue,
  ),
  if (instance.displayAmount case final $value?)
    'displayAmount': CommittedObligationOutput._write_displayAmount($value),
  'dueDate': ?instance.dueDate,
  'id': ?instance.id,
  'isOverdue': ?instance.isOverdue,
  'kind': ?CommittedObligationOutput._write_kind(instance.kind),
  if (instance.rateDate case final $value?)
    'rateDate': CommittedObligationOutput._write_rateDate($value),
  'rateSource': ?CommittedObligationOutput._write_rateSource(
    instance.rateSource,
  ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': CommittedObligationOutput._write_unconvertedReason(
      $value,
    ),
};
