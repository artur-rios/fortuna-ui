// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_manual_exchange_rate_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordManualExchangeRateCommand _$RecordManualExchangeRateCommandFromJson(
  Map<String, dynamic> json,
) => RecordManualExchangeRateCommand(
  baseCurrencyCode: json['baseCurrencyCode'] as String?,
  quoteCurrencyCode: json['quoteCurrencyCode'] as String?,
  rate: json['rate'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
);

Map<String, dynamic> _$RecordManualExchangeRateCommandToJson(
  RecordManualExchangeRateCommand instance,
) => <String, dynamic>{
  'baseCurrencyCode': instance.baseCurrencyCode,
  'quoteCurrencyCode': instance.quoteCurrencyCode,
  'rate': instance.rate,
  'rateDate': instance.rateDate?.toIso8601String(),
};
