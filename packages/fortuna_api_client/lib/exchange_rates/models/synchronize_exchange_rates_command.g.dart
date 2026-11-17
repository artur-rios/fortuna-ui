// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_exchange_rates_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeExchangeRatesCommand _$SynchronizeExchangeRatesCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['correlationId', 'requestedDate']);
  return SynchronizeExchangeRatesCommand(
    correlationId: !json.containsKey('correlationId')
        ? null
        : SynchronizeExchangeRatesCommand._read_correlationId(
            json['correlationId'],
          ),
    requestedDate: !json.containsKey('requestedDate')
        ? null
        : SynchronizeExchangeRatesCommand._read_requestedDate(
            json['requestedDate'],
          ),
  );
}

Map<String, dynamic> _$SynchronizeExchangeRatesCommandToJson(
  SynchronizeExchangeRatesCommand instance,
) => <String, dynamic>{
  if (instance.correlationId case final $value?)
    'correlationId': SynchronizeExchangeRatesCommand._write_correlationId(
      $value,
    ),
  if (instance.requestedDate case final $value?)
    'requestedDate': SynchronizeExchangeRatesCommand._write_requestedDate(
      $value,
    ),
};
