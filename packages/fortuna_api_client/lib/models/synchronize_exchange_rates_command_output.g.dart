// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_exchange_rates_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeExchangeRatesCommandOutput
_$SynchronizeExchangeRatesCommandOutputFromJson(Map<String, dynamic> json) =>
    SynchronizeExchangeRatesCommandOutput(
      jobId: json['jobId'] as String?,
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
    );

Map<String, dynamic> _$SynchronizeExchangeRatesCommandOutputToJson(
  SynchronizeExchangeRatesCommandOutput instance,
) => <String, dynamic>{
  'jobId': instance.jobId,
  'requestedDate': instance.requestedDate?.toIso8601String(),
};
