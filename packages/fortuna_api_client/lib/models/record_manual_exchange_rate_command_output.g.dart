// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommandOutput
_$RecordManualExchangeRateCommandOutputFromJson(Map<String, dynamic> json) =>
    RecordManualExchangeRateCommandOutput(
      baseCurrencyCode: json['baseCurrencyCode'] as String?,
      quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      replacedExisting: json['replacedExisting'] as bool?,
      source: json['source'] == null
          ? null
          : ExchangeRateSource.fromJson((json['source'] as num).toInt()),
      takesPrecedence: json['takesPrecedence'] as bool?,
    );

Map<String, dynamic> _$RecordManualExchangeRateCommandOutputToJson(
  RecordManualExchangeRateCommandOutput instance,
) => <String, dynamic>{
  'baseCurrencyCode': instance.baseCurrencyCode,
  'quoteCurrencyCode': instance.quoteCurrencyCode,
  'rate': instance.rate,
  'rateDate': instance.rateDate?.toIso8601String(),
  'replacedExisting': instance.replacedExisting,
  'source': instance.source,
  'takesPrecedence': instance.takesPrecedence,
};
