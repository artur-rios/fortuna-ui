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
    ],
  );
  return CommittedObligationOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    currencyCode: json['currencyCode'] as String?,
    cycleEnd: json['cycleEnd'] as String?,
    cycleStart: json['cycleStart'] as String?,
    daysOverdue: CommittedObligationOutput._read_daysOverdue(
      json['daysOverdue'],
    ),
    displayAmount: json['displayAmount'] as String?,
    dueDate: json['dueDate'] as String?,
    id: json['id'] as String?,
    isOverdue: json['isOverdue'] as bool?,
    kind: CommittedObligationOutput._read_kind(json['kind']),
    rateDate: json['rateDate'] as String?,
    rateSource: CommittedObligationOutput._read_rateSource(json['rateSource']),
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$CommittedObligationOutputToJson(
  CommittedObligationOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'currencyCode': ?instance.currencyCode,
  'cycleEnd': ?instance.cycleEnd,
  'cycleStart': ?instance.cycleStart,
  'daysOverdue': ?CommittedObligationOutput._write_daysOverdue(
    instance.daysOverdue,
  ),
  'displayAmount': ?instance.displayAmount,
  'dueDate': ?instance.dueDate,
  'id': ?instance.id,
  'isOverdue': ?instance.isOverdue,
  'kind': ?CommittedObligationOutput._write_kind(instance.kind),
  'rateDate': ?instance.rateDate,
  'rateSource': ?CommittedObligationOutput._write_rateSource(
    instance.rateSource,
  ),
  'unconvertedReason': ?instance.unconvertedReason,
};
