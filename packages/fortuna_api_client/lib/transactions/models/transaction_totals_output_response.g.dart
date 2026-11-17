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
    byCurrency: !json.containsKey('byCurrency')
        ? null
        : TransactionTotalsOutput$Response._read_byCurrency(json['byCurrency']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : TransactionTotalsOutput$Response._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    displayEarning: !json.containsKey('displayEarning')
        ? null
        : TransactionTotalsOutput$Response._read_displayEarning(
            json['displayEarning'],
          ),
    displayExpense: !json.containsKey('displayExpense')
        ? null
        : TransactionTotalsOutput$Response._read_displayExpense(
            json['displayExpense'],
          ),
    displayNet: !json.containsKey('displayNet')
        ? null
        : TransactionTotalsOutput$Response._read_displayNet(json['displayNet']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : TransactionTotalsOutput$Response._read_missingRates(
            json['missingRates'],
          ),
  );
}

Map<String, dynamic> _$TransactionTotalsOutput$ResponseToJson(
  TransactionTotalsOutput$Response instance,
) => <String, dynamic>{
  if (instance.byCurrency case final $value?)
    'byCurrency': TransactionTotalsOutput$Response._write_byCurrency($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        TransactionTotalsOutput$Response._write_displayCurrencyCode($value),
  if (instance.displayEarning case final $value?)
    'displayEarning': TransactionTotalsOutput$Response._write_displayEarning(
      $value,
    ),
  if (instance.displayExpense case final $value?)
    'displayExpense': TransactionTotalsOutput$Response._write_displayExpense(
      $value,
    ),
  if (instance.displayNet case final $value?)
    'displayNet': TransactionTotalsOutput$Response._write_displayNet($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': TransactionTotalsOutput$Response._write_missingRates(
      $value,
    ),
};
