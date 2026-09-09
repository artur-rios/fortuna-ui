// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_exchange_rates_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeExchangeRatesCommand _$SynchronizeExchangeRatesCommandFromJson(
  Map<String, dynamic> json,
) => SynchronizeExchangeRatesCommand(
  correlationId: json['correlationId'] as String?,
  requestedDate: json['requestedDate'] == null
      ? null
      : DateTime.parse(json['requestedDate'] as String),
);

Map<String, dynamic> _$SynchronizeExchangeRatesCommandToJson(
  SynchronizeExchangeRatesCommand instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'requestedDate': instance.requestedDate?.toIso8601String(),
};
