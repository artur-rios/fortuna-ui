// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committed_obligation_rate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommittedObligationRateOutput _$CommittedObligationRateOutputFromJson(
  Map<String, dynamic> json,
) => CommittedObligationRateOutput(
  baseCurrencyCode: json['baseCurrencyCode'] as String?,
  quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
  rate: (json['rate'] as num?)?.toDouble(),
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  source: json['source'] == null
      ? null
      : ExchangeRateSource.fromJson((json['source'] as num).toInt()),
);

Map<String, dynamic> _$CommittedObligationRateOutputToJson(
  CommittedObligationRateOutput instance,
) => <String, dynamic>{
  'baseCurrencyCode': instance.baseCurrencyCode,
  'quoteCurrencyCode': instance.quoteCurrencyCode,
  'rate': instance.rate,
  'rateDate': instance.rateDate?.toIso8601String(),
  'source': instance.source,
};
