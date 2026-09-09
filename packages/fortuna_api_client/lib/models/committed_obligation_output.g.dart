// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationOutput _$CommittedObligationOutputFromJson(
  Map<String, dynamic> json,
) => CommittedObligationOutput(
  amount: (json['amount'] as num?)?.toDouble(),
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String?,
  cycleEnd: json['cycleEnd'] == null
      ? null
      : DateTime.parse(json['cycleEnd'] as String),
  cycleStart: json['cycleStart'] == null
      ? null
      : DateTime.parse(json['cycleStart'] as String),
  daysOverdue: (json['daysOverdue'] as num?)?.toInt(),
  displayAmount: (json['displayAmount'] as num?)?.toDouble(),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  id: json['id'] as String?,
  isOverdue: json['isOverdue'] as bool?,
  kind: json['kind'] == null
      ? null
      : CommittedObligationKind.fromJson((json['kind'] as num).toInt()),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  rateSource: json['rateSource'] == null
      ? null
      : ExchangeRateSource.fromJson((json['rateSource'] as num).toInt()),
  unconvertedReason: json['unconvertedReason'] as String?,
);

Map<String, dynamic> _$CommittedObligationOutputToJson(
  CommittedObligationOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'appliedRate': instance.appliedRate,
  'currencyCode': instance.currencyCode,
  'cycleEnd': instance.cycleEnd?.toIso8601String(),
  'cycleStart': instance.cycleStart?.toIso8601String(),
  'daysOverdue': instance.daysOverdue,
  'displayAmount': instance.displayAmount,
  'dueDate': instance.dueDate?.toIso8601String(),
  'id': instance.id,
  'isOverdue': instance.isOverdue,
  'kind': instance.kind,
  'rateDate': instance.rateDate?.toIso8601String(),
  'rateSource': instance.rateSource,
  'unconvertedReason': instance.unconvertedReason,
};
