// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_currency_total_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCurrencyTotalOutput$Response
_$TransactionCurrencyTotalOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'currencyCode',
      'displayCurrencyCode',
      'displayEarning',
      'displayExpense',
      'displayNet',
      'earning',
      'expense',
      'net',
      'rateDate',
      'rateSource',
      'unconvertedReason',
    ],
    disallowNullValues: const ['earning', 'expense', 'net'],
  );
  return TransactionCurrencyTotalOutput$Response(
    appliedRate: json['appliedRate'] as String?,
    currencyCode: json['currencyCode'] as String?,
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    displayEarning: json['displayEarning'] as String?,
    displayExpense: json['displayExpense'] as String?,
    displayNet: json['displayNet'] as String?,
    earning: json['earning'] as String?,
    expense: json['expense'] as String?,
    net: json['net'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: TransactionCurrencyTotalOutput$Response._read_rateSource(
      json['rateSource'],
    ),
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$TransactionCurrencyTotalOutput$ResponseToJson(
  TransactionCurrencyTotalOutput$Response instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'currencyCode': ?instance.currencyCode,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'displayEarning': ?instance.displayEarning,
  'displayExpense': ?instance.displayExpense,
  'displayNet': ?instance.displayNet,
  'earning': ?instance.earning,
  'expense': ?instance.expense,
  'net': ?instance.net,
  'rateDate': ?instance.rateDate,
  'rateSource': ?TransactionCurrencyTotalOutput$Response._write_rateSource(
    instance.rateSource,
  ),
  'unconvertedReason': ?instance.unconvertedReason,
};
