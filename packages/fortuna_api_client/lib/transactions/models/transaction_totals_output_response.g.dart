// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTotalsOutput$Response _$TransactionTotalsOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'byCurrency',
      'displayCurrencyCode',
      'displayEarning',
      'displayExpense',
      'displayNet',
      'isFullyConverted',
      'missingRates',
    ],
    disallowNullValues: const ['isFullyConverted'],
  );
  return TransactionTotalsOutput$Response(
    byCurrency: (json['byCurrency'] as List<dynamic>?)
        ?.map(
          (e) => TransactionCurrencyTotalOutput$Response.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    displayEarning: json['displayEarning'] as String?,
    displayExpense: json['displayExpense'] as String?,
    displayNet: json['displayNet'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
  );
}

Map<String, dynamic> _$TransactionTotalsOutput$ResponseToJson(
  TransactionTotalsOutput$Response instance,
) => <String, dynamic>{
  'byCurrency': ?instance.byCurrency?.map((e) => e.toJson()).toList(),
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'displayEarning': ?instance.displayEarning,
  'displayExpense': ?instance.displayExpense,
  'displayNet': ?instance.displayNet,
  'isFullyConverted': ?instance.isFullyConverted,
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
};
