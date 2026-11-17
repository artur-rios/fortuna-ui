// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTotalsOutput$Request _$TransactionTotalsOutput$RequestFromJson(
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
  return TransactionTotalsOutput$Request(
    byCurrency: !json.containsKey('byCurrency')
        ? null
        : TransactionTotalsOutput$Request._read_byCurrency(json['byCurrency']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : TransactionTotalsOutput$Request._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    displayEarning: !json.containsKey('displayEarning')
        ? null
        : TransactionTotalsOutput$Request._read_displayEarning(
            json['displayEarning'],
          ),
    displayExpense: !json.containsKey('displayExpense')
        ? null
        : TransactionTotalsOutput$Request._read_displayExpense(
            json['displayExpense'],
          ),
    displayNet: !json.containsKey('displayNet')
        ? null
        : TransactionTotalsOutput$Request._read_displayNet(json['displayNet']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : TransactionTotalsOutput$Request._read_missingRates(
            json['missingRates'],
          ),
  );
}

Map<String, dynamic> _$TransactionTotalsOutput$RequestToJson(
  TransactionTotalsOutput$Request instance,
) => <String, dynamic>{
  if (instance.byCurrency case final $value?)
    'byCurrency': TransactionTotalsOutput$Request._write_byCurrency($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        TransactionTotalsOutput$Request._write_displayCurrencyCode($value),
  if (instance.displayEarning case final $value?)
    'displayEarning': TransactionTotalsOutput$Request._write_displayEarning(
      $value,
    ),
  if (instance.displayExpense case final $value?)
    'displayExpense': TransactionTotalsOutput$Request._write_displayExpense(
      $value,
    ),
  if (instance.displayNet case final $value?)
    'displayNet': TransactionTotalsOutput$Request._write_displayNet($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': TransactionTotalsOutput$Request._write_missingRates($value),
};
